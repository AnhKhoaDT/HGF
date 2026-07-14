import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin, urlparse
import re
import time
import unicodedata

try:
    from ddgs import DDGS
except ImportError:
    from duckduckgo_search import DDGS

from langchain.tools import tool
from config.settings import SEARCH_MAX_RESULTS, REQUEST_TIMEOUT
from utils.logger import get_logger

logger = get_logger(__name__)
MAX_IMAGES_PER_PAGE = 40

QUERY_STOP_WORDS = {
    "cac", "nhung", "dia", "diem", "du", "lich", "noi", "tieng",
    "dep", "tai", "gan", "voi", "the", "nao", "choi", "phai", "thu",
    "kinh", "nghiem", "duong", "mua", "gia", "tot", "ngon", "co",
    "gi", "khi", "den", "mot", "so", "ve", "cho",
}

def normalize_image_src(src: str, base_url: str) -> str | None:
    if not src:
        return None
    src = src.strip()
    if not src or src.startswith("data:"):
        return None
    if src.startswith("//"):
        src = f"https:{src}"
    return urljoin(base_url, src)

def first_src_from_srcset(srcset: str) -> str | None:
    if not srcset:
        return None
    first_item = srcset.split(",", 1)[0].strip()
    if not first_item:
        return None
    return first_item.split()[0]

def merge_images(*image_lists: list[dict], limit: int = MAX_IMAGES_PER_PAGE) -> list[dict]:
    images = []
    seen = set()
    for image_list in image_lists:
        for image in image_list or []:
            if not isinstance(image, dict):
                continue
            src = image.get("src")
            if not src or src in seen:
                continue
            seen.add(src)
            images.append(image)
            if len(images) >= limit:
                return images
    return images

def extract_metadata(soup):
    metadata = {}
    for meta in soup.find_all("meta"):
        key = meta.get("name") or meta.get("property") or meta.get("http-equiv")
        value = meta.get("content")
        if key and value:
            metadata[key] = value
    return metadata

def extract_images(soup, base_url):
    images = []
    for img in soup.find_all("img"):
        src = (
            img.get("src")
            or img.get("data-src")
            or img.get("data-original")
            or img.get("data-lazy-src")
            or first_src_from_srcset(img.get("srcset"))
        )
        src = normalize_image_src(src, base_url)
        if not src:
            continue
        images = merge_images(images, [{
            "src": urljoin(base_url, src),
            "alt": img.get("alt"),
            "title": img.get("title"),
        }])
    return images

def extract_images_from_markdown(text, base_url=None):
    images = []
    if not text:
        return images
    pattern = re.compile(r'!\[(?P<alt>.*?)\]\((?P<src>https?://[^\s)]+)(?:\s+"(?P<title>.*?)")?\)(?:_(?P<caption>[^_]+)_)?')
    for m in pattern.finditer(text):
        src = normalize_image_src(m.group("src"), base_url or "")
        if not src:
            continue
        alt = m.group("alt") or ""
        title = m.group("title") or (m.group("caption") and m.group("caption").strip()) or None
        images = merge_images(images, [{"src": src, "alt": alt, "title": title}])
    return images

def extract_links(soup, base_url):
    links = []
    for a in soup.find_all("a"):
        href = a.get("href")
        if not href: continue
        links.append({"text": a.get_text(" ", strip=True), "url": urljoin(base_url, href)})
    return links

def extract_headings(soup):
    headings = []
    for tag in ["h1", "h2", "h3", "h4"]:
        for node in soup.find_all(tag):
            headings.append({"tag": tag, "text": node.get_text(" ", strip=True)})
    return headings

def extract_json_ld(soup):
    schemas = []
    for script in soup.find_all("script", type="application/ld+json"):
        if script.string:
            schemas.append(script.string)
    return schemas

def normalize_text(value: str) -> str:
    value = (value or "").replace("Đ", "D").replace("đ", "d")
    value = unicodedata.normalize("NFD", value)
    value = "".join(ch for ch in value if unicodedata.category(ch) != "Mn")
    return value.lower()

def significant_tokens(value: str) -> set[str]:
    tokens = re.findall(r"[a-z0-9]+", normalize_text(value))
    return {token for token in tokens if len(token) >= 3 and token not in QUERY_STOP_WORDS}

def search_result_text(item: dict) -> str:
    return " ".join(str(item.get(key) or "") for key in ("title", "body", "href"))

def is_relevant_search_result(query: str, item: dict) -> bool:
    tokens = significant_tokens(query)
    if not tokens:
        return True

    haystack = normalize_text(search_result_text(item))
    score = sum(1 for token in tokens if token in haystack)
    required_score = min(3, max(1, len(tokens) // 3))
    return score >= required_score

def fetch_search_results(ddgs: DDGS, query: str, max_results: int) -> list[dict]:
    try:
        return list(ddgs.text(query, region="vn-vi", safesearch="moderate", max_results=max_results))
    except TypeError:
        return list(ddgs.text(query, max_results=max_results))

def scrape_url(url):
    logger.info(f"Scraping: {url}")
    result = {"url": url, "title": "", "metadata": {}, "images": [], "clean_text": ""}
    headers = {"User-Agent": "Mozilla/5.0"}

    # HTML
    try:
        html_response = requests.get(url, headers=headers, timeout=20)
        html_response.raise_for_status()
        soup = BeautifulSoup(html_response.text, "html.parser")
        if soup.title:
            result["title"] = soup.title.get_text(strip=True)
        result["metadata"] = extract_metadata(soup)
        result["images"] = extract_images(soup, url)
    except Exception as e:
        logger.error(f"HTML Error for {url}: {e}")

    # JINA
    try:
        jina_url = f"https://r.jina.ai/{url}"
        logger.info(f"Jina request: {jina_url}")
        text_response = requests.get(jina_url, headers=headers, timeout=60)
        text_response.raise_for_status()
        result["clean_text"] = text_response.text
        md_images = extract_images_from_markdown(result["clean_text"], url)
        if md_images:
            result["images"] = merge_images(result["images"], md_images)
        logger.info(
            f"Jina OK: {url} | status={text_response.status_code} | "
            f"chars={len(result['clean_text'])} | md_images={len(md_images)} | "
            f"total_images={len(result['images'])}"
        )
    except Exception as e:
        logger.error(f"Jina Error for {url}: {e}")

    return result

@tool
def search_and_scrape(query: str) -> dict:
    """Search DuckDuckGo for the query and scrape the top results. Returns scraped data including clean_text, metadata, and images."""
    logger.info(f"Searching & Scraping: {query}")
    ddgs = DDGS()
    try:
        search_limit = max(SEARCH_MAX_RESULTS * 4, SEARCH_MAX_RESULTS + 5)
        search_results = fetch_search_results(ddgs, query, search_limit)
    except Exception as e:
        logger.error(f"DDGS error: {e}")
        return {"query": query, "results": []}
        
    results = []
    for rank, item in enumerate(search_results, start=1):
        url = item.get("href")
        title = item.get("title") or ""
        if not url or not title.strip():
            continue

        if not is_relevant_search_result(query, item):
            domain = urlparse(url).netloc
            logger.info(f"Skipping low-relevance result: {domain or url}")
            continue

        try:
            page = scrape_url(url)
            page["search_rank"] = rank
            if not page.get("clean_text", "").strip():
                logger.info(f"Skipping empty scraped content: {url}")
                continue
            page["search_title"] = title
            results.append(page)
            logger.info(f"OK: {url}")
            if len(results) >= SEARCH_MAX_RESULTS:
                break
            time.sleep(1)
        except Exception as e:
            logger.error(f"Scrape error {url}: {e}")

    return {"query": query, "results": results}
