import '../../domain/entities/place_entity.dart';

class PlaceModel extends PlaceEntity {
  const PlaceModel({
    required super.id,
    required super.name,
    super.addressRaw,
    super.description,
    super.rating,
    super.imageUrl,
    super.images = const [],
    super.categoryId,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    final imagesList = <String>[];
    if (json['images'] is List) {
      for (final img in (json['images'] as List)) {
        if (img is Map<String, dynamic>) {
          final url = (img['image_url'] ?? img['src']) as String?;
          if (url != null && url.isNotEmpty) {
            imagesList.add(url);
          }
        } else if (img is String && img.isNotEmpty) {
          imagesList.add(img);
        }
      }
    }

    final firstImageUrl = (json['thumbnail'] as String?) ??
        (json['cover_image'] as String?) ??
        (json['image_url'] as String?) ??
        (imagesList.isNotEmpty ? imagesList.first : null);

    String? parsedDescription;
    if (json['description'] is String) {
      parsedDescription = json['description'] as String;
    } else if (json['description'] is Map && json['description']['text'] is String) {
      parsedDescription = json['description']['text'] as String;
    }

    final ratingVal = json['rating'];

    return PlaceModel(
      id: (json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      addressRaw: (json['address_raw'] ?? json['address']) as String?,
      description: parsedDescription,
      rating: ratingVal is num ? ratingVal.toDouble() : null,
      imageUrl: firstImageUrl,
      images: imagesList,
      categoryId: (json['category_id'] ?? json['category']) as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address_raw': addressRaw,
      'description': description,
      'rating': rating,
      'image_url': imageUrl,
      'images': images.map((url) => {'image_url': url}).toList(),
      'category_id': categoryId,
    };
  }
}
