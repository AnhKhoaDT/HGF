BEGIN;

-- Tùy chọn: Xóa sạch dữ liệu cũ nếu muốn làm mới hoàn toàn
-- TRUNCATE TABLE categories CASCADE;

-- ============================================================================
-- PHẦN 1: 8 DANH MỤC GỐC (ROOT CATEGORIES - parent_id IS NULL)
-- ============================================================================
WITH root_categories AS (
    INSERT INTO categories (id, parent_id, code, name, icon_url, color, description, metadata, status, created_by)
    VALUES 
    (gen_random_uuid(), NULL, 'SIGHTSEEING_NATURE', 'Sightseeing & Nature', 'https://api.iconify.design/flat-color-icons:landscape.svg', '#10B981', 'Scenic viewpoints, natural landscapes, cloud hunting spots, and breathtaking panoramas.', '{"is_root": true, "display_order": 1}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),
    (gen_random_uuid(), NULL, 'CULTURE_HERITAGE', 'Culture & Heritage', 'https://api.iconify.design/flat-color-icons:museum.svg', '#8B5CF6', 'Historical monuments, temples, museums, local villages, and architectural wonders.', '{"is_root": true, "display_order": 2}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),
    (gen_random_uuid(), NULL, 'FOOD_GASTRONOMY', 'Food & Gastronomy', 'https://api.iconify.design/flat-color-icons:dining-room.svg', '#F59E0B', 'Local restaurants, street food hubs, seafood markets, and traditional culinary spots.', '{"is_root": true, "display_order": 3}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),
    (gen_random_uuid(), NULL, 'CAFES_NIGHTLIFE', 'Cafes & Nightlife', 'https://api.iconify.design/flat-color-icons:beer.svg', '#D97706', 'Scenic view cafes, rooftop bars, acoustic pubs, clubs, and chill hangouts.', '{"is_root": true, "display_order": 4}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),
    (gen_random_uuid(), NULL, 'OUTDOOR_ACTIVITIES', 'Outdoor & Adventure', 'https://api.iconify.design/flat-color-icons:sports-mode.svg', '#3B82F6', 'Camping, glamping, trekking routes, water sports, and extreme adventures.', '{"is_root": true, "display_order": 5}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),
    (gen_random_uuid(), NULL, 'ENTERTAINMENT_RELAXATION', 'Entertainment & Relax', 'https://api.iconify.design/flat-color-icons:vip.svg', '#EC4899', 'Theme parks, hot springs, zoos, aquariums, and wellness spas.', '{"is_root": true, "display_order": 6}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),
    (gen_random_uuid(), NULL, 'ACCOMMODATION', 'Stays & Living', 'https://api.iconify.design/flat-color-icons:home.svg', '#06B6D4', 'Resorts, boutique hotels, homestays, private villas, and hostels.', '{"is_root": true, "display_order": 7}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),
    (gen_random_uuid(), NULL, 'SHOPPING_MARKETS', 'Shopping & Markets', 'https://api.iconify.design/flat-color-icons:shop.svg', '#14B8A6', 'Night markets, traditional bazaars, souvenir stores, and shopping malls.', '{"is_root": true, "display_order": 8}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid)
    RETURNING id, code
)
-- ============================================================================
-- PHẦN 2: 45+ DANH MỤC CON CHI TIẾT (LEAF CATEGORIES)
-- ============================================================================
INSERT INTO categories (id, parent_id, code, name, icon_url, color, description, metadata, status, created_by)
VALUES 
    -- ------------------------------------------------------------------------
    -- 1. SIGHTSEEING & NATURE (CHUYÊN SÂU NGẮM CẢNH & THIÊN NHIÊN)
    -- ------------------------------------------------------------------------
    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'SIGHTSEEING_NATURE'), 
     'VIEWPOINT_SUNSET', 'Sunset & Sunrise Viewpoints', 'https://api.iconify.design/flat-color-icons:sun.svg', '#F97316', 
     'Dedicated vantage points, coastal cliffs, and hilltop overlooks for watching sunrises and sunsets.', 
     '{"tags": ["sunset", "sunrise", "viewpoint", "romantic"], "ai_prompt_focus": ["best time for sunset/sunrise", "is there a parking fee", "crowd level"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'SIGHTSEEING_NATURE'), 
     'CLOUD_HUNTING', 'Cloud Hunting Spots', 'https://api.iconify.design/flat-color-icons:advance.svg', '#38BDF8', 
     'High-altitude mountain peaks and valleys famous for sea-of-clouds phenomena.', 
     '{"tags": ["cloud hunting", "mountain peak", "early morning"], "ai_prompt_focus": ["altitude in meters", "weather conditions needed for clouds", "road accessibility for motorbikes"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'SIGHTSEEING_NATURE'), 
     'SCENIC_DRIVE', 'Scenic Drives & Mountain Passes', 'https://api.iconify.design/flat-color-icons:automotive.svg', '#10B981', 
     'Breathtaking coastal roads, winding mountain passes, and picturesque routes for road tripping.', 
     '{"tags": ["scenic drive", "road trip", "mountain pass"], "ai_prompt_focus": ["road safety/curves", "total distance in km", "best stopover viewpoints along the road"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'SIGHTSEEING_NATURE'), 
     'LAKE_RESERVOIR', 'Lakes & Reservoirs', 'https://api.iconify.design/flat-color-icons:water-transportation.svg', '#06B6D4', 
     'Natural freshwater lakes, irrigation dams, and tranquil waterfront spots.', 
     '{"tags": ["lake", "reservoir", "waterfront", "peaceful"], "ai_prompt_focus": ["is fishing permitted", "boat rental prices", "water cleanliness"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'SIGHTSEEING_NATURE'), 
     'BEACH_COASTLINE', 'Beaches & Coastal Bays', 'https://api.iconify.design/flat-color-icons:beach.svg', '#0EA5E9', 
     'Sandy swimming beaches, rocky coastlines, crystal-clear lagoons, and tropical bays.', 
     '{"tags": ["beach", "sea", "swimming", "coastline"], "ai_prompt_focus": ["sand quality", "wave safety/undertow", "public shower availability"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'SIGHTSEEING_NATURE'), 
     'WATERFALL_STREAM', 'Waterfalls & Natural Streams', 'https://api.iconify.design/flat-color-icons:tree-structure.svg', '#0284C7', 
     'Cascading jungle waterfalls, rocky mountain streams, and natural forest swimming pools.', 
     '{"tags": ["waterfall", "stream", "nature swimming"], "ai_prompt_focus": ["water depth", "flash flood risks during monsoon", "walking distance from parking"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'SIGHTSEEING_NATURE'), 
     'FLOWER_VALLEY', 'Flower Gardens & Agricultural Valleys', 'https://api.iconify.design/flat-color-icons:globe.svg', '#EC4899', 
     'Seasonal flower fields, tea hills, terraced rice fields, and picturesque agricultural valleys.', 
     '{"tags": ["flower field", "tea hill", "terraced fields", "seasonal"], "ai_prompt_focus": ["blooming month/season", "entry ticket price", "best photo spots"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'SIGHTSEEING_NATURE'), 
     'CAVE_GEOLOGY', 'Caves & Geological Wonders', 'https://api.iconify.design/flat-color-icons:globe.svg', '#64748B', 
     'Limestone karst caves, stalactite grottoes, volcanic rocks, and unique geological formations.', 
     '{"tags": ["cave", "geology", "exploration"], "ai_prompt_focus": ["lighting inside cave", "humidity/temperature", "requires professional guide or easy walk"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    -- ------------------------------------------------------------------------
    -- 2. CULTURE & HERITAGE (VĂN HÓA, DI SẢN & TÂM LINH)
    -- ------------------------------------------------------------------------
    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'CULTURE_HERITAGE'), 
     'TEMPLE_PAGODA', 'Buddhist Pagodas & Temples', 'https://api.iconify.design/flat-color-icons:library.svg', '#7C3AED', 
     'Sacred Buddhist temples, ancient pagodas, monasteries, and spiritual sanctuaries.', 
     '{"tags": ["pagoda", "temple", "buddhism", "worship"], "ai_prompt_focus": ["strict dress code required", "historical age", "major annual festival dates"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'CULTURE_HERITAGE'), 
     'CHURCH_CATHEDRAL', 'Churches & Cathedrals', 'https://api.iconify.design/flat-color-icons:department.svg', '#6D28D9', 
     'Catholic cathedrals, historic wooden churches, and European-style religious architecture.', 
     '{"tags": ["church", "catholic", "architecture"], "ai_prompt_focus": ["weekend mass schedules", "architectural style", "is interior photography permitted"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'CULTURE_HERITAGE'), 
     'HISTORICAL_CITADEL', 'Historical Citadels & Palaces', 'https://api.iconify.design/flat-color-icons:court.svg', '#9333EA', 
     'Ancient imperial citadels, royal palaces, tombs of kings, and historic fortresses.', 
     '{"tags": ["citadel", "palace", "royal", "history"], "ai_prompt_focus": ["ticket price", "dynasty/historical period", "guided tour availability"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'CULTURE_HERITAGE'), 
     'WAR_MEMORIAL', 'War Relics & Memorial Sites', 'https://api.iconify.design/flat-color-icons:monument.svg', '#A855F7', 
     'War museums, historic battlefields, former secret bunkers, and revolution memorials.', 
     '{"tags": ["war relic", "history", "memorial"], "ai_prompt_focus": ["historical significance", "opening hours", "emotional sensitivity/appropriateness for kids"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'CULTURE_HERITAGE'), 
     'MUSEUM_EXHIBITION', 'Museums & Art Galleries', 'https://api.iconify.design/flat-color-icons:museum.svg', '#8B5CF6', 
     'National history museums, fine arts galleries, ethnic culture exhibitions, and specialized collections.', 
     '{"tags": ["museum", "exhibition", "art", "culture"], "ai_prompt_focus": ["main exhibition theme", "student discount", "time needed for full tour"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'CULTURE_HERITAGE'), 
     'CRAFT_VILLAGE', 'Traditional Craft & Ethnic Villages', 'https://api.iconify.design/flat-color-icons:home.svg', '#C084FC', 
     'Pottery villages, silk weaving hamlets, incense villages, and indigenous ethnic minority settlements.', 
     '{"tags": ["craft village", "local culture", "handicraft", "ethnic"], "ai_prompt_focus": ["can visitors try making crafts", "best time to see artisans working", "authentic souvenir buying tips"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    -- ------------------------------------------------------------------------
    -- 3. FOOD & GASTRONOMY (ẨM THỰC TRUYỀN THỐNG & ĐẶC SẢN)
    -- ------------------------------------------------------------------------
    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'FOOD_GASTRONOMY'), 
     'LOCAL_SPECIALTY_REST', 'Local Specialty Restaurants', 'https://api.iconify.design/flat-color-icons:dining-room.svg', '#EA580C', 
     'Famous dining establishments serving regional must-try delicacies and traditional recipes.', 
     '{"tags": ["specialty", "local food", "must-try", "restaurant"], "ai_prompt_focus": ["signature dish name", "average price per dish", "table reservation needed for dinner"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'FOOD_GASTRONOMY'), 
     'STREET_FOOD_ALLEY', 'Street Food & Food Alleys', 'https://api.iconify.design/flat-color-icons:shop.svg', '#F97316', 
     'Bustling food streets, hidden culinary alleys, local snack vendors, and cheap eats.', 
     '{"tags": ["street food", "snack", "cheap eats", "food alley"], "ai_prompt_focus": ["starting price from", "peak hours", "hygiene level/local popularity"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'FOOD_GASTRONOMY'), 
     'SEAFOOD_HUB', 'Seafood Restaurants & Floating Dining', 'https://api.iconify.design/flat-color-icons:database.svg', '#FB923C', 
     'Live seafood markets with cooking services, coastal seafood restaurants, and floating raft eateries.', 
     '{"tags": ["seafood", "fresh", "coastal", "floating restaurant"], "ai_prompt_focus": ["is seafood priced by weight", "freshness guarantee", "best cooking method recommended"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'FOOD_GASTRONOMY'), 
     'VEGETARIAN_VEGAN', 'Vegetarian & Vegan Dining', 'https://api.iconify.design/flat-color-icons:biotech.svg', '#10B981', 
     'Plant-based restaurants, Buddhist vegetarian eateries, and healthy organic dining spots.', 
     '{"tags": ["vegetarian", "vegan", "healthy", "plant-based"], "ai_prompt_focus": ["100% vegan or vegetarian", "buffet or a la carte", "monosodium glutamate (MSG) usage"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    -- ------------------------------------------------------------------------
    -- 4. CAFES & NIGHTLIFE (CÀ PHÊ VIEW, ROOFTOP & NIGHTLIFE)
    -- ------------------------------------------------------------------------
    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'CAFES_NIGHTLIFE'), 
     'CAFE_SCENIC_VIEW', 'Scenic & Valley View Cafes', 'https://api.iconify.design/flat-color-icons:gallery.svg', '#D97706', 
     'Coffee shops boasting panoramic mountain views, valley city lights, and breathtaking sunset angles.', 
     '{"tags": ["scenic cafe", "mountain view", "sunset cafe", "photo spot"], "ai_prompt_focus": ["what is the exact view", "average drink price", "best table location for photos"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'CAFES_NIGHTLIFE'), 
     'CAFE_GARDEN_CHILL', 'Garden & Acoustic Cafes', 'https://api.iconify.design/flat-color-icons:collaboration.svg', '#B45309', 
     'Lush green garden cafes, vintage wooden tea houses, and chill spots with live acoustic music.', 
     '{"tags": ["garden cafe", "chill", "acoustic", "vintage"], "ai_prompt_focus": ["live acoustic music schedule", "surcharge during music nights", "quietness during daytime"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'CAFES_NIGHTLIFE'), 
     'ROOFTOP_BAR', 'Rooftop Bars & Sky Lounges', 'https://api.iconify.design/flat-color-icons:podium-with-speaker.svg', '#C2410C', 
     'High-rise rooftop bars overlooking city skylines, craft cocktail lounges, and sunset wine bars.', 
     '{"tags": ["rooftop bar", "sky lounge", "cocktail", "nightlife"], "ai_prompt_focus": ["dress code requirements", "happy hour timings", "average cocktail price"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'CAFES_NIGHTLIFE'), 
     'CLUB_PUB_NIGHTLIFE', 'Clubs, Pubs & Live Music Bars', 'https://api.iconify.design/flat-color-icons:music.svg', '#9A3412', 
     'Vibrant dance clubs, DJ parties, underground pubs, craft beer taprooms, and late-night nightlife.', 
     '{"tags": ["club", "pub", "nightlife", "party", "dj"], "ai_prompt_focus": ["entrance cover charge", "music genre (EDM, HipHop, Rock)", "closing time"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    -- ------------------------------------------------------------------------
    -- 5. OUTDOOR & ADVENTURE (CẮM TRẠI & THỂ THAO MẠO HIỂM)
    -- ------------------------------------------------------------------------
    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'OUTDOOR_ACTIVITIES'), 
     'CAMPING_DIY', 'DIY Camping Grounds', 'https://api.iconify.design/flat-color-icons:radar-plot.svg', '#059669', 
     'Natural lakeside or forest clearings where travelers can pitch their own tents and build campfires.', 
     '{"tags": ["diy camping", "tent", "campfire", "nature"], "ai_prompt_focus": ["is there an entry/pitch fee", "fresh water and toilet availability", "safety at night"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'OUTDOOR_ACTIVITIES'), 
     'GLAMPING_SERVICE', 'Luxury Glamping Campsites', 'https://api.iconify.design/flat-color-icons:home.svg', '#10B981', 
     'Full-service glamorous camping with pre-setup luxury tents, air conditioning, comfy beds, and BBQ dinners.', 
     '{"tags": ["glamping", "luxury camping", "bbq included"], "ai_prompt_focus": ["package price per person/tent", "what amenities are inside the tent", "is breakfast/BBQ included"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'OUTDOOR_ACTIVITIES'), 
     'TREKKING_TRAIL', 'Trekking & Hiking Trails', 'https://api.iconify.design/flat-color-icons:tree-structure.svg', '#15803D', 
     'Mountain climbing paths, forest hiking routes, and multi-day wilderness trekking expeditions.', 
     '{"tags": ["trekking", "hiking", "climbing", "adventure"], "ai_prompt_focus": ["total distance and elevation gain", "difficulty rating (easy, moderate, hard)", "leech warnings"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'OUTDOOR_ACTIVITIES'), 
     'WATER_SPORTS', 'SUP, Kayaking & Water Sports', 'https://api.iconify.design/flat-color-icons:rower.svg', '#0284C7', 
     'Stand-up paddleboarding (SUP), kayaking, white-water rafting, surfing, and jet skiing.', 
     '{"tags": ["sup", "kayak", "water sports", "surfing"], "ai_prompt_focus": ["hourly rental rates", "life jacket inclusion", "beginner training provided"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'OUTDOOR_ACTIVITIES'), 
     'EXTREME_ADVENTURE', 'Paragliding, Zipline & Extreme Sports', 'https://api.iconify.design/flat-color-icons:sports-mode.svg', '#1E40AF', 
     'Paragliding over valleys, high-speed forest ziplines, rock climbing, and skydiving centers.', 
     '{"tags": ["paragliding", "zipline", "extreme sports", "adrenaline"], "ai_prompt_focus": ["insurance coverage included", "weight/age limits", "flight/ride duration"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    -- ------------------------------------------------------------------------
    -- 6. ENTERTAINMENT & RELAXATION (VUI CHƠI, CHECK-IN & THƯ GIÃN)
    -- ------------------------------------------------------------------------
    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'ENTERTAINMENT_RELAXATION'), 
     'THEME_AMUSEMENT_PARK', 'Theme & Amusement Parks', 'https://api.iconify.design/flat-color-icons:roller-coaster.svg', '#DB2777', 
     'Large-scale entertainment complexes, roller coasters, water parks, and fantasy theme worlds.', 
     '{"tags": ["theme park", "water park", "amusement", "family"], "ai_prompt_focus": ["all-in-one entrance fee", "fast-pass availability", "must-play thrill rides"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'ENTERTAINMENT_RELAXATION'), 
     'PHOTO_STUDIO_CHECKIN', 'Photo Studios & Concept Check-ins', 'https://api.iconify.design/flat-color-icons:camera.svg', '#EC4899', 
     'Artificial photo villages, stairway to heaven installations, costume rental studios, and art spaces.', 
     '{"tags": ["photo spot", "check-in", "studio", "costume rental"], "ai_prompt_focus": ["ticket price with drink included", "traditional costume rental cost", "best photo angles"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'ENTERTAINMENT_RELAXATION'), 
     'HOT_SPRING_ONSEN', 'Hot Springs, Mud Baths & Onsen', 'https://api.iconify.design/flat-color-icons:heat-map.svg', '#E11D48', 
     'Natural thermal mineral waters, therapeutic mud bath centers, Japanese-style Onsens, and health spas.', 
     '{"tags": ["hot spring", "mud bath", "onsen", "wellness"], "ai_prompt_focus": ["private tub vs shared pool rates", "health benefits", "towel/swimwear rental"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'ENTERTAINMENT_RELAXATION'), 
     'ZOO_SAFARI_FARM', 'Zoos, Safaris & Petting Farms', 'https://api.iconify.design/flat-color-icons:fujifilm.svg', '#BE185D', 
     'Open wildlife safaris, sheep farms, puppy/cat cafes, agricultural farms, and marine aquariums.', 
     '{"tags": ["zoo", "safari", "petting farm", "animals", "kids"], "ai_prompt_focus": ["animal feeding times", "can visitors interact/touch animals", "kid-friendly facilities"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    -- ------------------------------------------------------------------------
    -- 7. ACCOMMODATION (LƯU TRÚ & NGHỈ DƯỠNG CHI TIẾT)
    -- ------------------------------------------------------------------------
    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'ACCOMMODATION'), 
     'RESORT_BEACHFRONT', 'Beachfront & Luxury Resorts', 'https://api.iconify.design/flat-color-icons:vip.svg', '#06B6D4', 
     '4 to 5-star oceanfront resorts, private villas with infinity pools, and luxury holiday retreats.', 
     '{"tags": ["resort", "luxury", "beachfront", "5 star"], "ai_prompt_focus": ["private beach access", "infinity pool view", "buffet breakfast quality"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'ACCOMMODATION'), 
     'ECO_LODGE_MOUNTAIN', 'Mountain Eco-Lodges & Bungalows', 'https://api.iconify.design/flat-color-icons:home.svg', '#0891B2', 
     'Nature-immersed wooden bungalows, eco-friendly forest lodges, and hilltop cabins.', 
     '{"tags": ["eco lodge", "bungalow", "nature stay", "mountain"], "ai_prompt_focus": ["is there air conditioning or natural cool air", "mosquito protection", "valley view from balcony"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'ACCOMMODATION'), 
     'HOMESTAY_AESTHETIC', 'Aesthetic Homestays & Boutiques', 'https://api.iconify.design/flat-color-icons:shop.svg', '#0E7490', 
     'Beautifully styled homestays (Vintage, Bohemian, Minimalist) with cozy atmospheres and friendly hosts.', 
     '{"tags": ["homestay", "aesthetic", "cozy", "boutique"], "ai_prompt_focus": ["room decor style", "shared kitchen/BBQ yard availability", "host hospitality"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'ACCOMMODATION'), 
     'VILLA_PRIVATE_POOL', 'Private Pool Villas for Groups', 'https://api.iconify.design/flat-color-icons:home.svg', '#164E63', 
     'Entire multi-bedroom villas featuring private swimming pools, kitchens, and BBQ gardens for group reunions.', 
     '{"tags": ["private villa", "whole house", "private pool", "group stay"], "ai_prompt_focus": ["number of bedrooms/max capacity", "BBQ cleaning surcharge", "noise restrictions after 10 PM"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    -- ------------------------------------------------------------------------
    -- 8. SHOPPING & MARKETS (CHỢ & MUA SẮM ĐẶC SẢN)
    -- ------------------------------------------------------------------------
    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'SHOPPING_MARKETS'), 
     'MARKET_NIGHT_WALKING', 'Night Markets & Walking Streets', 'https://api.iconify.design/flat-color-icons:shop.svg', '#0D9488', 
     'Vibrant evening pedestrian streets and night bazaars packed with street food, clothes, and local souvenirs.', 
     '{"tags": ["night market", "walking street", "souvenirs", "bustling"], "ai_prompt_focus": ["operating days of week", "must-visit food stalls inside market", "pickpocket/crowd awareness"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'SHOPPING_MARKETS'), 
     'MARKET_TRADITIONAL', 'Traditional Wet & Seafood Markets', 'https://api.iconify.design/flat-color-icons:database.svg', '#0F766E', 
     'Authentic morning local markets, wholesale seafood hubs, and agricultural produce trading centers.', 
     '{"tags": ["traditional market", "wet market", "seafood market", "local life"], "ai_prompt_focus": ["best time to visit in early morning", "seafood foam box packing service", "bargaining norms"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid),

    (gen_random_uuid(), (SELECT id FROM root_categories WHERE code = 'SHOPPING_MARKETS'), 
     'SHOP_SPECIALTY_GIFT', 'Specialty Gift & Souvenir Stores', 'https://api.iconify.design/flat-color-icons:neutral-trading.svg', '#2DD4BF', 
     'Trusted stores selling regional dried seafood, specialty coffee, local tea, wine, and artisan handicrafts.', 
     '{"tags": ["souvenir store", "specialty gifts", "local handicrafts", "trusted"], "ai_prompt_focus": ["top recommended souvenir items", "fixed transparent pricing vs bargaining", "flight-ready packaging"]}'::jsonb, 'active', '00000000-0000-0000-0000-000000000000'::uuid);

COMMIT;