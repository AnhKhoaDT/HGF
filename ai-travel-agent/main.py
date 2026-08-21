import argparse
import json
import re
from agent.workflow import run_workflow
from utils.logger import get_logger

logger = get_logger("main")

def safe_str(s):
    return f"'{s.replace(chr(39), chr(39)+chr(39))}'" if s else "NULL"

def safe_json(j):
    if j is None:
        j = {}
    return f"'{json.dumps(j, ensure_ascii=False).replace(chr(39), chr(39)+chr(39))}'::jsonb"

def safe_num(n):
    return str(n) if n is not None else "NULL"

def output_prefix(location: str) -> str:
    slug = location.strip()
    slug = re.sub(r"[.。．,，;；:：!！?？]+$", "", slug)
    slug = re.sub(r"\s+", "_", slug)
    slug = re.sub(r'[\\/:*?"<>|]+', "_", slug)
    slug = re.sub(r"_+", "_", slug).strip("_")
    return f"places_{slug or 'results'}"

def generate_sql(places: list) -> str:
    sql_lines = ["BEGIN;\n"]
    for place in places:
        category_id = f"'{place['category_id']}'" if place.get('category_id') else "NULL"
        division_id = f"'{place['division_id']}'" if place.get('division_id') else "NULL"
        
        aliases = "ARRAY[" + ",".join([f"'{a.replace(chr(39), chr(39)+chr(39))}'" for a in place.get('aliases', [])]) + "]::text[]" if place.get('aliases') else "ARRAY[]::text[]"
        
        query = f"""INSERT INTO places (
            category_id, division_id, name, aliases, short_description, description,
            address, lat, lng, thumbnail, cover_image, images, rating, review_count,
            popularity_score, attributes, ai_data, source_data, status, created_by
        ) VALUES (
            {category_id}, {division_id}, {safe_str(place['name'])}, {aliases}, {safe_str(place.get('short_description'))}, {safe_str(place.get('description'))},
            {safe_str(place.get('address'))}, {safe_num(place.get('lat'))}, {safe_num(place.get('lng'))}, {safe_str(place.get('thumbnail'))}, {safe_str(place.get('cover_image'))}, {safe_json(place.get('images', []))}, {safe_num(place.get('rating'))}, {safe_num(place.get('review_count'))},
            {safe_num(place.get('popularity_score'))}, {safe_json(place.get('attributes', {}))}, {safe_json(place.get('ai_data', {}))}, {safe_json(place.get('source_data', {}))}, 'active', '00000000-0000-0000-0000-000000000000'
        );"""
        sql_lines.append(query)
    
    sql_lines.append("\nCOMMIT;")
    return "\n".join(sql_lines)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="AI Travel Agent")
    parser.add_argument("--loc", type=str, required=True, help="Location to search for")
    args = parser.parse_args()
    
    try:
        results = run_workflow(args.loc)
        prefix = output_prefix(args.loc)
        
        # 1. Output JSON
        json_file = f"{prefix}.json"
        with open(json_file, "w", encoding="utf-8") as f:
            json.dump(results, f, ensure_ascii=False, indent=2)
            
        # 2. Output SQL
        sql_content = generate_sql(results)
        sql_file = f"{prefix}.sql"
        with open(sql_file, "w", encoding="utf-8") as f:
            f.write(sql_content)
            
        logger.info(f"Successfully saved {len(results)} places to {json_file} and {sql_file}")
    except Exception as e:
        logger.error(f"Workflow failed: {e}")
