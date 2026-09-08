import 'package:equatable/equatable.dart';

class PlaceEntity extends Equatable {
  final String id;
  final String name;
  final String? addressRaw;
  final String? description;
  final double? rating;
  final String? imageUrl;
  final List<String> images;
  final String? categoryId;

  const PlaceEntity({
    required this.id,
    required this.name,
    this.addressRaw,
    this.description,
    this.rating,
    this.imageUrl,
    this.images = const [],
    this.categoryId,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        addressRaw,
        description,
        rating,
        imageUrl,
        images,
        categoryId,
      ];
}
