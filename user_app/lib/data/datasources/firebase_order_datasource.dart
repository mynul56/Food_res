import 'package:cloud_functions/cloud_functions.dart';
import '../../domain/entities/order_entity.dart';

class FirebaseOrderDatasource {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<void> placeOrder(OrderEntity order, String userId) async {
    try {
      await _functions.httpsCallable('placeOrder').call({
        'order': order.toJson(),
      });
    } catch (e) {
      throw Exception('Failed to place order via backend: $e');
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await _functions.httpsCallable('updateOrderStatus').call({
        'id': orderId,
        'status': status.name,
      });
    } catch (e) {
      throw Exception('Failed to update order status via backend: $e');
    }
  }

  Future<List<OrderEntity>> getUserOrders(String userId) async {
    try {
      final result = await _functions.httpsCallable('getUserOrders').call();
      final List<dynamic> data = result.data;
      return data
          .map((item) =>
              OrderEntity.fromJson(Map<String, dynamic>.from(item), item['id']))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch user orders via backend: $e');
    }
  }

  Future<List<OrderEntity>> getAllOrders() async {
    try {
      final result = await _functions.httpsCallable('getAdminOrders').call();
      final List<dynamic> data = result.data;
      return data
          .map((item) =>
              OrderEntity.fromJson(Map<String, dynamic>.from(item), item['id']))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch all orders via backend: $e');
    }
  }
}
