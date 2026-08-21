import json
import re
import unicodedata
from agent.chains import generate_queries, extract_places
from tools.search_tool import search_and_scrape
from database.master_data import load_categories, load_provinces
from config.settings import (
    EXTRACT_TEXT_MAX_LENGTH,
    MAX_IMAGES_PER_PLACE,
    MAX_SCRAPED_DOCUMENTS,
    MAX_SEARCH_QUERIES,
)
from utils.logger import get_logger
from utils.text_cleaner import clean_text

logger = get_logger(__name__)

def normalize_key(value: str) -> str:
    value = (value or "").replace("Đ", "D").replace("đ", "d")
    value = unicodedata.normalize("NFD", value)
    value = "".join(ch for ch in value if unicodedata.category(ch) != "Mn")
    value = re.sub(r"[^a-zA-Z0-9]+", " ", value).strip().lower()
    return re.sub(r"\s+", " ", value)

def dedupe_queries(queries: list[str]) -> list[str]:
    seen = set()
    unique_queries = []
    for query in queries:
        key = normalize_key(query)
        if not key or key in seen:
            continue
        seen.add(key)
        unique_queries.append(query.strip())
    return unique_queries

def dedupe_images(images: list[dict], limit: int = MAX_IMAGES_PER_PLACE) -> list[dict]:
    seen = set()
    unique_images = []
    for image in images or []:
        if not isinstance(image, dict):
            continue
        src = image.get("src")
        if not src or src in seen:
            continue
        seen.add(src)
        unique_images.append(image)
        if len(unique_images) >= limit:
            break
    return unique_images

def merge_unique_strings(current: list[str], incoming: list[str]) -> list[str]:
    values = []
    seen = set()
    for item in (current or []) + (incoming or []):
        if not item:
            continue
        key = normalize_key(str(item))
        if key in seen:
            continue
        seen.add(key)
        values.append(item)
    return values

def merge_dict(current: dict, incoming: dict) -> dict:
    merged = dict(current or {})
    for key, value in (incoming or {}).items():
        if value in (None, "", [], {}):
            continue
        if key not in merged or merged[key] in (None, "", [], {}):
            merged[key] = value
        elif isinstance(merged[key], list) and isinstance(value, list):
            merged[key] = merge_unique_strings(merged[key], value)
    return merged

def richer_text(current: str | None, incoming: str | None) -> str | None:
    if not current:
        return incoming
    if incoming and len(incoming) > len(current):
        return incoming
    return current

def merge_place(existing: dict, incoming: dict) -> dict:
    merged = dict(existing)
    for field in ("category_id", "division_id", "address", "lat", "lng", "rating", "review_count", "popularity_score", "thumbnail", "cover_image", "status"):
        if merged.get(field) in (None, "", [], {}) and incoming.get(field) not in (None, "", [], {}):
            merged[field] = incoming.get(field)

    for field in ("short_description", "description"):
        merged[field] = richer_text(merged.get(field), incoming.get(field))

    merged["aliases"] = merge_unique_strings(merged.get("aliases", []), incoming.get("aliases", []))
    merged["images"] = dedupe_images((merged.get("images") or []) + (incoming.get("images") or []))
    merged["attributes"] = merge_dict(merged.get("attributes", {}), incoming.get("attributes", {}))
    merged["ai_data"] = merge_dict(merged.get("ai_data", {}), incoming.get("ai_data", {}))
    merged["source_data"] = merge_dict(merged.get("source_data", {}), incoming.get("source_data", {}))

    if not merged.get("thumbnail") and merged["images"]:
        merged["thumbnail"] = merged["images"][0].get("src")
    if not merged.get("cover_image") and merged["images"]:
        merged["cover_image"] = merged["images"][0].get("src")
    return merged

def build_scraped_block(query: str, page: dict) -> str:
    text_content = clean_text(page.get("clean_text", ""), max_length=EXTRACT_TEXT_MAX_LENGTH)
    metadata = page.get("metadata", {})
    images = dedupe_images(page.get("images", []), limit=20)
    source = {
        "query": query,
        "url": page.get("url", ""),
        "search_title": page.get("search_title", ""),
        "page_title": page.get("title", ""),
    }
    return (
        f"Source: {json.dumps(source, ensure_ascii=False)}\n"
        f"Metadata: {json.dumps(metadata, ensure_ascii=False)}\n"
        f"Images: {json.dumps(images, ensure_ascii=False)}\n"
        f"Content:\n{text_content}"
    )

def run_workflow(location: str):
    logger.info(f"--- STARTING AI TRAVEL AGENT FOR: {location} ---")
    
    cats = load_categories()
    provs = load_provinces()
    
    division_id = None
    for p in provs:
        if p.get("name") and p["name"].lower() in location.lower():
            division_id = p["id"]
            break
            
    cat_mapping = json.dumps([{"id": c["id"], "name": c["name"]} for c in cats], ensure_ascii=False)
    
    queries = dedupe_queries(generate_queries(location))[:MAX_SEARCH_QUERIES]
    logger.info(f"Generated {len(queries)} queries.")
    
    place_index = {}
    seen_urls = set()
    scraped_count = 0

    for q in queries:
        if scraped_count >= MAX_SCRAPED_DOCUMENTS:
            break

        try:
            res = search_and_scrape.invoke({"query": q})
            for r in res.get("results", []):
                url = r.get("url", "")
                url_key = url.split("#", 1)[0]
                if not url_key or url_key in seen_urls:
                    continue

                if not r.get("clean_text", "").strip():
                    continue

                seen_urls.add(url_key)
                scraped_count += 1
                block = build_scraped_block(q, r)
                logger.info(f"Extracting places from document {scraped_count}: {url}")
                places = extract_places(location, division_id, cat_mapping, block)
                logger.info(f"Extracted {len(places)} place candidates from document {scraped_count}.")

                for place in places:
                    place_data = place.model_dump()
                    page_source_data = {
                        "urls": [url],
                        "queries": [q],
                    }
                    source_title = r.get("search_title") or r.get("title")
                    if source_title:
                        page_source_data["titles"] = [source_title]
                    place_data["source_data"] = merge_dict(page_source_data, place_data.get("source_data", {}))
                    name_key = normalize_key(place_data.get("name", ""))
                    if not name_key:
                        continue
                    if name_key in place_index:
                        place_index[name_key] = merge_place(place_index[name_key], place_data)
                    else:
                        place_index[name_key] = merge_place(place_data, {})

                if scraped_count >= MAX_SCRAPED_DOCUMENTS:
                    break
        except Exception as e:
            logger.error(f"Error during search_and_scrape for query '{q}': {e}")
    
    if not place_index:
        logger.error("No places extracted.")
        return []
    
    places = list(place_index.values())
    logger.info(f"Extracted {len(places)} unique places from {scraped_count} documents.")
    return places
