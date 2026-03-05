import 'package:equatable/equatable.dart';

enum OrderSubmitStatus { initial, submitting, success, failure }

class OrderState extends Equatable {
  final OrderSubmitStatus status;
  final String? orderId;
  final String? errorMessage;

  const OrderState({
    this.status = OrderSubmitStatus.initial,
    this.orderId,
    this.errorMessage,
  });

  OrderState copyWith({
    OrderSubmitStatus? status,
    String? orderId,
    String? errorMessage,
  }) {
    return OrderState(
      status: status ?? this.status,
      orderId: orderId ?? this.orderId,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, orderId, errorMessage];
}
