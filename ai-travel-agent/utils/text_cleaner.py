import re

def clean_text(text: str, max_length: int = 30000) -> str:
    """
    Cleans and truncates text to avoid exceeding LLM context windows.
    """
    if not text:
        return ""
    
    # Remove multiple spaces and newlines
    cleaned = re.sub(r'\s+', ' ', text).strip()
    
    if len(cleaned) > max_length:
        cleaned = cleaned[:max_length] + "..."
        
    return cleaned
