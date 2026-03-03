class FoodEntity {
  final String id;
  final String name;
  final String category;
  final double price;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final String description;
  final bool isPopular;
  final int calories;
  final int prepTimeMinutes;
  final bool isFavorite;

  const FoodEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.description,
    this.isPopular = false,
    required this.calories,
    required this.prepTimeMinutes,
    this.isFavorite = false,
  });

  FoodEntity copyWith({bool? isFavorite}) {
    return FoodEntity(
      id: id,
      name: name,
      category: category,
      price: price,
      rating: rating,
      reviewCount: reviewCount,
      imageUrl: imageUrl,
      description: description,
      isPopular: isPopular,
      calories: calories,
      prepTimeMinutes: prepTimeMinutes,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
