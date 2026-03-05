import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

/// Start a payment attempt for an orderr.
class PaymentStartedEvent extends PaymentEvent {
  final String orderId;
  final double amount;

  const PaymentStartedEvent({
    required this.orderId,
    required this.amount,
  });

  @override
  List<Object?> get props => [orderId, amount];
}

/// Mock result (temporary until Stripe is intergrated)
class PaymentMockApprovedEvent extends PaymentEvent {
  const PaymentMockApprovedEvent();
}

class PaymentMockDeclinedEvent extends PaymentEvent {
  final String? reason;

  const PaymentMockDeclinedEvent({this.reason});

  @override
  List<Object?> get props => [reason];
}

class PaymentResetEvent extends PaymentEvent {
  const PaymentResetEvent();
}
