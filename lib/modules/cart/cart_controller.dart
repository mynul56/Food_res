import 'package:get/get.dart';
import '../../domain/entities/food_entity.dart';
import '../../domain/entities/cart_item_entity.dart';

class CartController extends GetxController {
  final cartItems = <CartItemEntity>[].obs;
  final isLoading = false.obs;

  // ── Derived values ──────────────────────────────────────────
  int get itemCount => cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => cartItems.fold(0.0, (sum, item) => sum + item.total);
  double get deliveryFee => subtotal > 0 ? 2.99 : 0.0;
  double get total => subtotal + deliveryFee;

  bool isInCart(String foodId) => cartItems.any((i) => i.food.id == foodId);
  int quantityOf(String foodId) {
    final item = cartItems.firstWhereOrNull((i) => i.food.id == foodId);
    return item?.quantity ?? 0;
  }

  // ── Actions ────────────────────────────────────────────────
  void addItem(FoodEntity food) {
    final index = cartItems.indexWhere((i) => i.food.id == food.id);
    if (index >= 0) {
      cartItems[index] = cartItems[index].copyWith(
        quantity: cartItems[index].quantity + 1,
      );
    } else {
      cartItems.add(CartItemEntity(food: food, quantity: 1));
    }
  }

  void removeItem(FoodEntity food) {
    final index = cartItems.indexWhere((i) => i.food.id == food.id);
    if (index >= 0) {
      if (cartItems[index].quantity > 1) {
        cartItems[index] = cartItems[index].copyWith(
          quantity: cartItems[index].quantity - 1,
        );
      } else {
        cartItems.removeAt(index);
      }
    }
  }

  void deleteItem(String foodId) {
    cartItems.removeWhere((i) => i.food.id == foodId);
  }

  void clearCart() => cartItems.clear();

  void placeOrder() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    clearCart();
    isLoading.value = false;
  }
}
