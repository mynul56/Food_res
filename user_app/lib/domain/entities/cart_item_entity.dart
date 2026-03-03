import 'food_entity.dart';

class CartItemEntity {
  final FoodEntity food;
  int quantity;

  CartItemEntity({
    required this.food,
    this.quantity = 1,
  });

  double get total => food.price * quantity;

  CartItemEntity copyWith({int? quantity}) {
    return CartItemEntity(
      food: food,
      quantity: quantity ?? this.quantity,
    );
  }

  factory CartItemEntity.fromJson(Map<String, dynamic> json) {
    return CartItemEntity(
      food: FoodEntity.fromJson(json['food'] ?? {}, json['food']['id'] ?? ''),
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'food': food.toJson()
        ..addAll(
            {'id': food.id}), // Ensure ID is saved along with food attributes
      'quantity': quantity,
    };
  }
}
