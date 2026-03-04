import '../../domain/models/order.dart' as domain;

abstract class OrderRepository {
  /// Creates an order in the backend and returns the generated orderId.
  Future<String> createOrder(domain.Order order);

  /// Optional: update order status later (PAID/FAILED/etc).
  Future<void> updateOrderStatus({
    required String orderId,
    required String status, // store as "PENDING"/"PAID"/...
  });
}
