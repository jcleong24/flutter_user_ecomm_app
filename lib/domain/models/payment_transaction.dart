import '../enums/payment_status.dart';

class PaymentTransaction {
  final String transactionId;
  final double amount;
  final PaymentStatus status;
  final String? responseCode;
  final String? responseMessage;
  final DateTime createdAt;

  const PaymentTransaction({
    required this.transactionId,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.responseCode,
    this.responseMessage,
  });

  Map<String, dynamic> toJson() => {
        'transactionId': transactionId,
        'amount': amount,
        'status': status.name,
        'responseCode': responseCode,
        'responseMessage': responseMessage,
        'createdAt': createdAt.toIso8601String(),
      };
}
