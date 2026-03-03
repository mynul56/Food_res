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

  factory OrderEntity.fromJson(Map<String, dynamic> json, String id) {
    final statusString = json['status'] as String? ?? 'accepted';
    final parsedStatus = OrderStatus.values.firstWhere(
      (e) => e.name == statusString,
      orElse: () => OrderStatus.accepted,
    );

    return OrderEntity(
      id: id,
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => CartItemEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] ?? 0.0).toDouble(),
      deliveryFee: (json['deliveryFee'] ?? 0.0).toDouble(),
      discount: (json['discount'] ?? 0.0).toDouble(),
      restaurantName: json['restaurantName'] ?? '',
      status: parsedStatus,
      placedAt: json['placedAt'] != null
          ? DateTime.parse(json['placedAt'] as String)
          : DateTime.now(),
      address: json['address'],
      paymentMethod: json['paymentMethod'] ?? 'Cash on Delivery',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'restaurantName': restaurantName,
      'status': status.name,
      'placedAt': placedAt.toIso8601String(),
      'address': address,
      'paymentMethod': paymentMethod,
    };
  }
}
