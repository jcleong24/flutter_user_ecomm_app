import 'package:equatable/equatable.dart';
import 'package:flutter_user_ecomm_app/domain/models/cart_item.dart';

class CartState extends Equatable {
  final List<CartItem> cartItems;

  const CartState({this.cartItems = const []});

  double get totalAmount =>
      cartItems.fold(0, (sum, item) => sum + item.subtotal);

  int get totalQuantity =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => cartItems.isEmpty;

  @override
  List<Object?> get props => [cartItems];
}
