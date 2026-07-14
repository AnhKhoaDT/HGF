import os
from dotenv import load_dotenv

load_dotenv()

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
JINA_API_KEY = os.getenv("JINA_API_KEY")
DATABASE_URL = os.getenv("DATABASE_URL")

def _int_env(name: str, default: int) -> int:
    try:
        return int(os.getenv(name, default))
    except (TypeError, ValueError):
        return default

# Configurations
SEARCH_MAX_RESULTS = _int_env("SEARCH_MAX_RESULTS", 3)
REQUEST_TIMEOUT = _int_env("REQUEST_TIMEOUT", 30)
MAX_SEARCH_QUERIES = _int_env("MAX_SEARCH_QUERIES", 20)
MAX_SCRAPED_DOCUMENTS = _int_env("MAX_SCRAPED_DOCUMENTS", 24)
EXTRACT_TEXT_MAX_LENGTH = _int_env("EXTRACT_TEXT_MAX_LENGTH", 12000)
MAX_IMAGES_PER_PLACE = _int_env("MAX_IMAGES_PER_PLACE", 8)
