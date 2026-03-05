import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user_ecomm_app/domain/bloc/payment/payment_event.dart';
import 'package:flutter_user_ecomm_app/domain/bloc/payment/payment_state.dart';

import '../../../data/repositories/order_repository.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../enums/payment_status.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository paymentRepository;
  final OrderRepository orderRepository;

  PaymentBloc({
    required this.paymentRepository,
    required this.orderRepository,
  }) : super(const PaymentState()) {
    on<PaymentStartedEvent>(_onStartedEvent);
    on<PaymentMockApprovedEvent>(_onMockApprovedEvent);
    on<PaymentMockDeclinedEvent>(_onMockDeclinedEvent);
    on<PaymentResetEvent>(_onResetEvent);
  }

  Future<void> _onStartedEvent(
    PaymentStartedEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(
      status: PaymentStatus.initiated,
      orderId: event.orderId,
      amount: event.amount,
      transactionId: null,
      errorMessage: null,
    ));

    try {
      final transactionId = await paymentRepository.createTransaction(
        orderId: event.orderId,
        amount: event.amount,
      );
      emit(state.copyWith(
        status: PaymentStatus.initiated,
        transactionId: transactionId,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PaymentStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onMockApprovedEvent(
    PaymentMockApprovedEvent event,
    Emitter<PaymentState> emit,
  ) async {
    final orderId = state.orderId;
    final txnId = state.transactionId;

    if (orderId == null || txnId == null) {
      emit(state.copyWith(
        status: PaymentStatus.error,
        errorMessage: 'Order ID or Transaction ID is null',
      ));
      return;
    }

    try {
      await paymentRepository.updateTransactionStatus(
          orderId: orderId,
          transactionId: txnId,
          status: PaymentStatus.approved,
          responseCode: '00',
          responseMessage: 'APPROVED (MOCK)');

      await orderRepository.updateOrderStatus(orderId: orderId, status: 'PAID');

      emit(state.copyWith(status: PaymentStatus.approved));
    } catch (e) {
      emit(state.copyWith(
        status: PaymentStatus.error,
        errorMessage: e.toString(),
      ));
      return;
    }
  }

  Future<void> _onMockDeclinedEvent(
      PaymentMockDeclinedEvent event, Emitter<PaymentState> emit) async {
    final orderId = state.orderId;
    final txnId = state.transactionId;

    if (orderId == null || txnId == null) {
      emit(state.copyWith(
        status: PaymentStatus.error,
        errorMessage: 'Payment not started yet.',
      ));
      return;
    }

    try {
      await paymentRepository.updateTransactionStatus(
        orderId: orderId,
        transactionId: txnId,
        status: PaymentStatus.declined,
        responseCode: '05',
        responseMessage: event.reason ?? 'DECLINED (MOCK)',
      );

      await orderRepository.updateOrderStatus(
        orderId: orderId,
        status: 'FAILED',
      );

      emit(state.copyWith(
        status: PaymentStatus.declined,
        errorMessage: event.reason ?? 'Payment declined.',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PaymentStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onResetEvent(PaymentResetEvent event, Emitter<PaymentState> emit) {
    emit(const PaymentState());
  }
}
