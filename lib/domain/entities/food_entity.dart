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

  factory FoodEntity.fromJson(Map<String, dynamic> json, String id) {
    return FoodEntity(
      id: id,
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? '',
      isPopular: json['isPopular'] ?? false,
      calories: json['calories'] ?? 0,
      prepTimeMinutes: json['prepTimeMinutes'] ?? 0,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'rating': rating,
      'reviewCount': reviewCount,
      'imageUrl': imageUrl,
      'description': description,
      'isPopular': isPopular,
      'calories': calories,
      'prepTimeMinutes': prepTimeMinutes,
      'isFavorite': isFavorite,
    };
  }
}
