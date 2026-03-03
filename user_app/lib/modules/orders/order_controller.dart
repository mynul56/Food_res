import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../cart/cart_controller.dart';
import 'package:flutter/foundation.dart';
import '../../data/datasources/firebase_order_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderController extends GetxController {
  final activeOrder = Rx<OrderEntity?>(null);
  final orderHistory = <OrderEntity>[].obs;
  final trackingStep = 0.obs; // 0–3 maps to OrderStatus

  final FirebaseOrderDatasource _orderDatasource = FirebaseOrderDatasource();

  @override
  void onInit() {
    super.onInit();
    _fetchOrderHistory();
  }

  Future<void> _fetchOrderHistory() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      try {
        final orders = await _orderDatasource.getUserOrders(userId);
        orderHistory.assignAll(orders);
      } catch (e) {
        debugPrint('Error placing order: $e');
      }
    }
  }

  // Returns true if there is an undelivered active order
  bool get hasActiveOrder =>
      activeOrder.value != null &&
      activeOrder.value!.status != OrderStatus.delivered;

  Future<void> placeOrder({
    required CartController cart,
    String restaurantName = 'NulEat Kitchen',
    String address = '42 Maple Street, Dhaka',
    String paymentMethod = 'Cash on Delivery',
  }) async {
    final items = List<CartItemEntity>.from(cart.cartItems);
    final subtotal = cart.subtotal;
    final deliveryFee = cart.deliveryFee;
    final discount = cart.promoDiscount.value;

    final order = OrderEntity(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      discount: discount,
      restaurantName: restaurantName,
      status: OrderStatus.accepted,
      placedAt: DateTime.now(),
      address: address,
      paymentMethod: paymentMethod,
    );

    activeOrder.value = order;
    trackingStep.value = 0;
    cart.clearCart();

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      try {
        await _orderDatasource.placeOrder(order, userId);
      } catch (e) {
        Get.snackbar('Error', 'Failed to save order to cloud: $e');
      }
    }

    Get.offAllNamed(AppRoutes.orderTracking);

    // Auto-advance tracking steps
    await Future.delayed(const Duration(seconds: 3));
    _advanceStatus(OrderStatus.preparing);

    await Future.delayed(const Duration(seconds: 5));
    _advanceStatus(OrderStatus.outForDelivery);

    await Future.delayed(const Duration(seconds: 6));
    _advanceStatus(OrderStatus.delivered);

    // Move to history
    if (activeOrder.value != null) {
      orderHistory.insert(0, activeOrder.value!);
    }
  }

  void _advanceStatus(OrderStatus status) async {
    if (activeOrder.value == null) return;

    final order = activeOrder.value!;
    activeOrder.value = order.copyWith(status: status);
    trackingStep.value = status.index;

    // Attempt to update the status in Firebase
    try {
      await _orderDatasource.updateOrderStatus(order.id, status);
    } catch (e) {
      debugPrint('Warning: Failed to sync status with Firebase: $e');
    }
  }

  void reorder(OrderEntity order, CartController cart) {
    for (final item in order.items) {
      for (int i = 0; i < item.quantity; i++) {
        cart.addItem(item.food);
      }
    }
    Get.toNamed(AppRoutes.cart);
  }
}
