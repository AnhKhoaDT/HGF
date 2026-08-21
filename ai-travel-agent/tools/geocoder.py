from langchain.tools import tool
from utils.logger import get_logger

logger = get_logger(__name__)

@tool
def geocode_address(address: str) -> dict:
    """Mock geocoder to return lat/lng for an address."""
    logger.info(f"Geocoding address (Mock): {address}")
    return {"lat": None, "lng": None}
