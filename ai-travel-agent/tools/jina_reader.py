from langchain.tools import tool
import requests
from config.settings import REQUEST_TIMEOUT
from utils.logger import get_logger
from utils.text_cleaner import clean_text

logger = get_logger(__name__)

@tool
def scrape_with_jina(url: str) -> str:
    """Scrape a URL using r.jina.ai and return clean markdown text."""
    logger.info(f"Scraping with Jina: {url}")
    try:
        jina_url = f"https://r.jina.ai/{url}"
        logger.info(f"Jina request: {jina_url}")
        headers = {"User-Agent": "Mozilla/5.0"}
        response = requests.get(jina_url, headers=headers, timeout=REQUEST_TIMEOUT)
        response.raise_for_status()
        cleaned_text = clean_text(response.text)
        logger.info(
            f"Jina OK: {url} | status={response.status_code} | "
            f"raw_chars={len(response.text)} | clean_chars={len(cleaned_text)}"
        )
        return cleaned_text
    except Exception as e:
        logger.error(f"Error scraping {url}: {e}")
        return ""
