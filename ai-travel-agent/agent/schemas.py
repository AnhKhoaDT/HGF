from pydantic import BaseModel, Field
from typing import List, Optional, Dict, Any

class ImageModel(BaseModel):
    src: str = Field(..., description="Image URL")
    alt: Optional[str] = Field(None, description="Image alt text or title")

class PlaceModel(BaseModel):
    category_id: Optional[str] = Field(None, description="UUID of the category this place belongs to.")
    division_id: Optional[str] = Field(None, description="UUID of the administrative division (e.g. city/province).")
    name: str = Field(..., description="Name of the place")
    aliases: List[str] = Field(default_factory=list, description="Alternative names or aliases")
    short_description: Optional[str] = Field(None, description="A brief 1-2 sentence description")
    description: Optional[str] = Field(None, description="Detailed description or review of the place")
    address: Optional[str] = Field(None, description="Full address of the place")
    lat: Optional[float] = Field(None, description="Latitude (leave null if unknown)")
    lng: Optional[float] = Field(None, description="Longitude (leave null if unknown)")
    thumbnail: Optional[str] = Field(None, description="URL of a thumbnail image")
    cover_image: Optional[str] = Field(None, description="URL of a high quality cover image")
    images: List[ImageModel] = Field(default_factory=list, description="List of other images found")
    rating: Optional[float] = Field(None, description="Average rating out of 5 (e.g., 4.5)")
    review_count: Optional[int] = Field(None, description="Number of reviews")
    popularity_score: Optional[float] = Field(None, description="Popularity score from 0 to 10")
    attributes: Dict[str, Any] = Field(default_factory=dict, description="Additional properties like ticket_price, opening_hours, etc.")
    ai_data: Dict[str, Any] = Field(default_factory=dict, description="AI analysis like tags, sentiment, best_time_to_visit.")
    source_data: Dict[str, Any] = Field(default_factory=dict, description="Source info like {'urls': ['http...']}")
    status: str = Field("active", description="Always 'active'")

class PlacesList(BaseModel):
    places: List[PlaceModel] = Field(..., description="List of places extracted from the content")
