import 'package:flutter_user_ecomm_app/domain/enums/order_status.dart';
import 'package:flutter_user_ecomm_app/domain/models/cart_item.dart';

class Order {
  final String id;
  final DateTime createdAt;
  final List<CartItem> items;
  OrderStatus status;

  Order({
    required this.id,
    required this.items,
    required this.createdAt,
    this.status = OrderStatus.pending,
  });

  double get totalAmount => items.fold(0, (sum, item) => sum + item.subtotal);

  void markAsPaid() {
    status = OrderStatus.paid;
  }

  void markAsFailed() {
    status = OrderStatus.failed;
  }

  void cancel() {
    status = OrderStatus.cancelled;
  }
}
