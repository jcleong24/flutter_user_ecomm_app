import 'package:equatable/equatable.dart';
import 'package:flutter_user_ecomm_app/domain/models/cart_item.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class OrderPlacedEvent extends OrderEvent {
  final List<CartItem> cartItems;
  const OrderPlacedEvent(this.cartItems);

  @override
  List<Object?> get props => [cartItems];
}

class OrderReset extends OrderEvent {
  const OrderReset();
}
