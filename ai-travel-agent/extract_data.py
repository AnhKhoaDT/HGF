import re
import json
import os

def parse_sql(file_path, is_category=False):
    data = []
    if not os.path.exists(file_path):
        return data
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Simple regex to extract the VALUES tuples
    pattern = r"\('([^']+)',\s*([^,]+),\s*'([^']+)',\s*'([^']+)'"
    
    for match in re.finditer(pattern, content):
        uid = match.group(1)
        parent_id = match.group(2).strip("'") if match.group(2) != "NULL" else None
        
        if is_category:
            code = match.group(3)
            name = match.group(4)
            data.append({"id": uid, "parent_id": parent_id, "code": code, "name": name})
        else:
            level = match.group(3)
            name = match.group(4)
            data.append({"id": uid, "parent_id": parent_id, "level": level, "name": name})
            
    return data

if __name__ == "__main__":
    cat_path = "/Users/hienlazada/Plan-Travel/python/generate_system_data/import_categories.sql"
    prov_path = "/Users/hienlazada/Plan-Travel/python/generate_system_data/import_admin_divisions.sql"
    
    cats = parse_sql(cat_path, True)
    provs = parse_sql(prov_path, False)
    
    with open("system_data/categories.json", "w", encoding="utf-8") as f:
        json.dump(cats, f, ensure_ascii=False, indent=2)
        
    with open("system_data/provinces.json", "w", encoding="utf-8") as f:
        json.dump(provs, f, ensure_ascii=False, indent=2)
    
    print(f"Extracted {len(cats)} categories and {len(provs)} provinces/divisions.")
