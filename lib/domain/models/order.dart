import '../enums/order_status.dart';
import 'order_item.dart';

class Order {
  final String id; // empty before assigning Firestore
  final double totalAmount;
  final OrderStatus status;
  final DateTime createdAt;
  final List<OrderItem> items;

  const Order({
    required this.id,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  Order copyWith({
    String? id,
    double? totalAmount,
    OrderStatus? status,
    DateTime? createdAt,
    List<OrderItem>? items,
  }) =>
      Order(
        id: id ?? this.id,
        totalAmount: totalAmount ?? this.totalAmount,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        items: items ?? this.items,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'totalAmount': totalAmount,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'items': items.map((item) => item.toJson()).toList(),
      };

  static Order fromCartItems({
    required List<OrderItem> items,
  }) {
    final total = items.fold<double>(0.0, (sum, i) => sum + i.subtotal);

    return Order(
      id: '',
      totalAmount: total,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
      items: items,
    );
  }
}
