import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/enums/payment_status.dart';
import '../../domain/models/payment_transaction.dart';

abstract class PaymentRepository {
  Future<void> createTransaction(PaymentTransaction txn);

  Future<void> updateTransactionStatus({
    required String
        orderId, // keeps payment attempts tightly scoped to an order
    required String transactionId,
    required PaymentStatus status,
    String? responseCode,
    String? responseMessage,
  });
}

class FirebasePaymentRepository implements PaymentRepository {
  final FirebaseFirestore firestore;

  FirebasePaymentRepository(this.firestore);

  @override
  Future<void> createTransaction(PaymentTransaction txn) async {
    // final docRef = await firestore.collection('payment_transactions').add({
    await firestore
        .collection('orders')
        .doc(txn.orderId)
        .collection('payment_transactions')
        .doc(txn.transactionId)
        .set(txn.toJson());
  }

  @override
  Future<void> updateTransactionStatus({
    required String orderId,
    required String transactionId,
    required PaymentStatus status,
    String? responseCode,
    String? responseMessage,
  }) async {
    await firestore
        .collection('orders')
        .doc(orderId)
        .collection('payment_transactions')
        .doc(transactionId)
        .update({
      'status': status.name.toUpperCase(),
      'responseCode': responseCode,
      'responseMessage': responseMessage,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
