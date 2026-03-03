import 'cart_item_entity.dart';

enum OrderStatus { accepted, preparing, outForDelivery, delivered }

extension OrderStatusX on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.accepted:
        return 'Order Accepted';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  String get emoji {
    switch (this) {
      case OrderStatus.accepted:
        return '✅';
      case OrderStatus.preparing:
        return '👨‍🍳';
      case OrderStatus.outForDelivery:
        return '🛵';
      case OrderStatus.delivered:
        return '🎉';
    }
  }
}

class OrderEntity {
  final String id;
  final List<CartItemEntity> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final String restaurantName;
  final OrderStatus status;
  final DateTime placedAt;
  final String? address;
  final String paymentMethod;

  const OrderEntity({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.restaurantName,
    required this.status,
    required this.placedAt,
    this.discount = 0.0,
    this.address,
    this.paymentMethod = 'Cash on Delivery',
  });

  double get total => subtotal + deliveryFee - discount;

  String get itemsSummary {
    if (items.isEmpty) return 'No items';
    final names = items.map((i) => '${i.quantity}× ${i.food.name}').join(', ');
    return names;
  }

  OrderEntity copyWith({OrderStatus? status}) {
    return OrderEntity(
      id: id,
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      discount: discount,
      restaurantName: restaurantName,
      status: status ?? this.status,
      placedAt: placedAt,
      address: address,
      paymentMethod: paymentMethod,
    );
  }
}
