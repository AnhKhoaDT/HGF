import json
from langchain_google_genai import ChatGoogleGenerativeAI
from agent.prompts import QUERY_GENERATOR_PROMPT, EXTRACTOR_PROMPT
from agent.schemas import PlacesList
from config.settings import GEMINI_API_KEY
from utils.logger import get_logger

logger = get_logger(__name__)

# Khởi tạo mô hình
llm = ChatGoogleGenerativeAI(
    model="gemini-3.5-flash",
    google_api_key=GEMINI_API_KEY,
    temperature=0.2
)

def fallback_queries(location: str) -> list[str]:
    return [
        f"top địa điểm nổi tiếng ở {location}",
        f"{location} có gì chơi địa điểm check-in",
        f"review du lịch {location} địa điểm đẹp",
        f"địa điểm du lịch tự nhiên ở {location}",
        f"chùa di tích văn hóa ở {location}",
        f"khu dã ngoại cắm trại picnic ở {location}",
        f"quán ăn ngon đặc sản ở {location}",
        f"nhà hàng hải sản ở {location}",
        f"cafe đẹp check-in ở {location}",
        f"khách sạn resort homestay ở {location}",
        f"chợ mua đặc sản ở {location}",
        f"Google Maps địa điểm nổi bật ở {location}",
    ]

def generate_queries(location: str) -> list[str]:
    logger.info(f"Generating queries for {location}...")
    chain = QUERY_GENERATOR_PROMPT | llm
    res = chain.invoke({"location": location})
    
    try:
        content = res.content
        if isinstance(content, list):
            content = content[0].get("text", "") if isinstance(content[0], dict) else str(content[0])
        elif not isinstance(content, str):
            content = str(content)
        content = content.strip()
        
        if content.startswith("```json"):
            content = content[7:-3].strip()
        elif content.startswith("```"):
            content = content[3:-3].strip()
        queries = json.loads(content)
        if not isinstance(queries, list):
            raise ValueError("query generator did not return a list")
        queries = [q.strip() for q in queries if isinstance(q, str) and q.strip()]
        if len(queries) < 5:
            queries.extend(fallback_queries(location))
        return queries
    except Exception as e:
        logger.error(f"Error parsing queries: {e}")
        return fallback_queries(location)

def extract_places(location: str, division_id: str, categories_str: str, content: str):
    logger.info(f"Extracting places for {location}...")
    structured_llm = llm.with_structured_output(PlacesList)
    chain = EXTRACTOR_PROMPT | structured_llm
    
    try:
        res = chain.invoke({
            "location": location,
            "division_id": division_id or "",
            "categories": categories_str,
            "content": content
        })
        return res.places
    except Exception as e:
        logger.error(f"Error extracting places: {e}")
        return []
