import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/order_entity.dart';

class FirebaseOrderDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> placeOrder(OrderEntity order, String userId) async {
    try {
      final orderJson = order.toJson();
      orderJson['userId'] = userId; // Associate order with the user

      await _firestore.collection('orders').doc(order.id).set(orderJson);
    } catch (e) {
      throw Exception('Failed to place order: $e');
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': status.name,
      });
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  Future<List<OrderEntity>> getUserOrders(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('placedAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => OrderEntity.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch user orders: $e');
    }
  }

  Future<List<OrderEntity>> getAllOrders() async {
    try {
      final snapshot = await _firestore
          .collection('orders')
          .orderBy('placedAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => OrderEntity.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch all orders: $e');
    }
  }
}
