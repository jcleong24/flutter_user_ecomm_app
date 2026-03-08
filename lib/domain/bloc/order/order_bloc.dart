import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user_ecomm_app/domain/bloc/order/order_event.dart';
import 'package:flutter_user_ecomm_app/domain/bloc/order/order_state.dart';

import '../../../data/repositories/order_repository.dart';
import '../../enums/order_status.dart';
import '../../models/cart_item.dart';
import '../../models/order.dart' as domain;
import '../../models/order_item.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;

  OrderBloc({required this.orderRepository}) : super(const OrderState()) {
    on<OrderPlacedEvent>(_onOrderPlaced);
    on<OrderReset>(_onReset);
  }

  Future<void> _onOrderPlaced(
    OrderPlacedEvent event,
    Emitter<OrderState> emit,
  ) async {
    if (event.cartItems.isEmpty) {
      emit(state.copyWith(
        status: OrderSubmitStatus.failure,
        errorMessage: 'Cart is empty.',
      ));
      return;
    }

    emit(state.copyWith(
      status: OrderSubmitStatus.submitting,
      errorMessage: null,
      orderId: null,
    ));

    try {
      final orderItems = _toOrderItems(event.cartItems);

      final order = domain.Order(
        id: '',
        totalAmount: orderItems.fold(0.0, (sum, i) => sum + i.subtotal),
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
        items: orderItems,
      );

      final createdOrderId = await orderRepository.createOrder(order);

      emit(state.copyWith(
        status: OrderSubmitStatus.success,
        orderId: createdOrderId,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OrderSubmitStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onReset(OrderReset event, Emitter<OrderState> emit) {
    emit(const OrderState());
  }

  List<OrderItem> _toOrderItems(List<CartItem> cartItems) {
    return cartItems.map((c) {
      final p = c.product;
      return OrderItem(
        productId: p.id,
        name: p.name,
        price: p.price,
        quantity: c.quantity,
        thumbnailUrl: p.thumbnailUrl,
      );
    }).toList();
  }
}
