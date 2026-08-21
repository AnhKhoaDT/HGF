from langchain_core.prompts import ChatPromptTemplate

QUERY_GENERATOR_SYS_PROMPT = """You are an expert Vietnamese travel data researcher.
Your task is to generate flexible search queries that discover named places and businesses in the requested location.
Do NOT limit the search to classic tourist attractions. Cover every useful place type a travel app should store:
- famous attractions, scenic spots, beaches, mountains, lakes, hot springs
- check-in/photo spots, picnic/camping/outdoor activity places
- temples, pagodas, churches, historical/cultural sites
- restaurants, seafood spots, local specialty eateries, street food places
- cafes, nightlife, chill places
- hotels, resorts, homestays, guest houses
- markets, shopping streets, souvenir/local specialty shops
- "what to do", review/list pages, maps, and local guide pages

Generate 18-24 Vietnamese queries. Mix broad discovery queries and specific intent queries.
Always include the exact requested location words. If the request contains a district and province, include both in most queries.
Prefer queries that return lists of named places, not only generic descriptions.

Output exactly a JSON list of strings, without markdown block or other text.
Example: ["top địa điểm nổi tiếng ở ...", "quán ăn ngon ở ...", "khách sạn homestay đẹp ở ..."]
"""

QUERY_GENERATOR_PROMPT = ChatPromptTemplate.from_messages([
    ("system", QUERY_GENERATOR_SYS_PROMPT),
    ("human", "Generate search queries for the following location: {location}")
])

EXTRACTOR_SYS_PROMPT = """You are an expert data extractor AI for a travel application.
Given one scraped page or a small content batch about a location, extract every named place/business that is useful for travelers.
Include attractions, check-in spots, restaurants, cafes, hotels/resorts/homestays, markets, shops, outdoor activities, and cultural sites.
Do not extract generic category names, provinces, districts, or article section headings as places.
Map each extracted place to the best category_id from the provided categories mapping. The categories are for classification only; they must not restrict what you extract.
Map the place to the provided division_id.
If latitude, longitude, rating, review count, opening hours, price, or other specific details are not found in the text, leave them as null or put clearly sourced details in attributes.
Use the ai_data field to add tags, sentiment, best time to visit, suitable_for, and notes based on the text context.
Use the source_data field to log source URLs and page titles when known (pass urls in {{"urls": [...]}}).

Image rules:
- The input may include an Images JSON array from the scraped page.
- Choose multiple images that are relevant to each specific place when available, up to 8 images per place.
- Prefer images whose alt/title/caption/URL appears related to the place name or surrounding content.
- Set thumbnail and cover_image from relevant images only.
- Do NOT reuse one unrelated image for all places. If no related image is available for a place, leave thumbnail/cover_image null and images empty.

Quality rules:
- Extract places one by one with separate records. Do not merge different places into one record.
- Prefer the requested location. Include nearby places only when the content clearly presents them as useful for this request.
- Do NOT hallucinate information. If you don't know an address, leave it as null or provide only a rough area based on the text.
"""

EXTRACTOR_PROMPT = ChatPromptTemplate.from_messages([
    ("system", EXTRACTOR_SYS_PROMPT),
    ("human", "Location: {location}\nDivision ID: {division_id}\nCategories Mapping:\n{categories}\n\nScraped Content:\n{content}")
])
