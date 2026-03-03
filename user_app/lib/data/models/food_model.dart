import '../../domain/entities/food_entity.dart';

class FoodModel extends FoodEntity {
  const FoodModel({
    required super.id,
    required super.name,
    required super.category,
    required super.price,
    required super.rating,
    required super.reviewCount,
    required super.imageUrl,
    required super.description,
    super.isPopular,
    required super.calories,
    required super.prepTimeMinutes,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['review_count'],
      imageUrl: json['image_url'],
      description: json['description'],
      isPopular: json['is_popular'] ?? false,
      calories: json['calories'],
      prepTimeMinutes: json['prep_time_minutes'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'rating': rating,
      'review_count': reviewCount,
      'image_url': imageUrl,
      'description': description,
      'is_popular': isPopular,
      'calories': calories,
      'prep_time_minutes': prepTimeMinutes,
    };
  }
}
