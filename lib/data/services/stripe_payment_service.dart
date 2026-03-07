import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class StripePaymentService {
  final FirebaseFunctions functions;

  StripePaymentService(this.functions);

  Future<Map<String, dynamic>> createPaymentIntent({
    required String orderId,
    required String transactionId,
    required int amountInCents,
    String currency = 'myr',
  }) async {
    final callable = functions.httpsCallable('createPaymentIntent');

    final res = await callable.call({
      'orderId': orderId,
      'transactionId': transactionId,
      'amount': amountInCents,
      'currency': currency,
    });

    debugPrint('Calling function with cents=$amountInCents');
    final data = Map<String, dynamic>.from(res.data as Map);
    return data;
  }
}
