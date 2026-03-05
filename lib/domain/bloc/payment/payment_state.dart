import 'package:equatable/equatable.dart';

import '../../enums/payment_status.dart';

class PaymentState extends Equatable {
  final PaymentStatus status;
  final String? orderId;
  final String? transactionId;
  final double? amount;
  final String? errorMessage;

  const PaymentState({
    this.status = PaymentStatus.initial,
    this.orderId,
    this.transactionId,
    this.amount,
    this.errorMessage,
  });

  PaymentState copyWith({
    PaymentStatus? status,
    String? orderId,
    String? transactionId,
    double? amount,
    String? errorMessage,
  }) {
    return PaymentState(
      status: status ?? this.status,
      orderId: orderId ?? this.orderId,
      transactionId: transactionId ?? this.transactionId,
      amount: amount ?? this.amount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        orderId,
        transactionId,
        amount,
        errorMessage,
      ];
}
