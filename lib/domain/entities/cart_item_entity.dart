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
}
