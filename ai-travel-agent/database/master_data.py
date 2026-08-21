import os
import re

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

def load_categories():
    path = os.path.join(os.path.dirname(__file__), '..', 'system_data', 'import_categories.sql')
    return parse_sql(path, True)

def load_provinces():
    path = os.path.join(os.path.dirname(__file__), '..', 'system_data', 'import_admin_divisions.sql')
    return parse_sql(path, False)
