import 'package:cloud_firestore/cloud_firestore.dart';

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

class FirebaseOrderRepository implements OrderRepository {
  final FirebaseFirestore firestore;

  FirebaseOrderRepository(this.firestore);

  @override
  Future<String> createOrder(domain.Order order) async {
    final docRef = await firestore.collection('orders').add({
      'totalAmount': order.totalAmount,
      'status': order.status.name,
      'createdAt': order.createdAt.toIso8601String(),
      'items': order.items.map((item) => item.toJson()).toList(),
    });

    // generated orderId from firestore
    await docRef.update({'id': docRef.id});

    return docRef.id;
  }

  @override
  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    await firestore.collection('orders').doc(orderId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
