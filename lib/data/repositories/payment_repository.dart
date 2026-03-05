import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/enums/payment_status.dart';
import '../../domain/models/payment_transaction.dart';

abstract class PaymentRepository {
  Future<String> createTransaction(
      {required String orderId, required double amount});

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
  Future<String> createTransaction(
      {required String orderId, required double amount}) async {
    // final docRef = await firestore.collection('payment_transactions').add({
    final docRef = firestore
        .collection('orders')
        .doc(orderId)
        .collection('payment_transactions')
        .doc();

    final txn = PaymentTransaction(
        transactionId: docRef.id,
        orderId: orderId,
        amount: amount,
        status: PaymentStatus.initiated,
        createdAt: DateTime.now(),
        responseCode: null,
        responseMessage: null);

    await docRef.set({
      ...txn.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
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
