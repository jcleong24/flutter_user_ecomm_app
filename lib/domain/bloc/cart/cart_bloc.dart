import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user_ecomm_app/domain/bloc/cart/cart_event.dart';
import 'package:flutter_user_ecomm_app/domain/bloc/cart/cart_state.dart';
import '../../models/cart_item.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<CartItemAddedEvent>(_onCartItemAdded);
    on<CartItemRemovedEvent>(_onCartItemRemoved);
    on<CartItemQtyIncreaseEvent>(_onQtyIncreased);
    on<CartItemQtyDecreaseEvent>(_onQtyDecreased);
    on<CartClearedEvent>(_onCartClear);
  }

  void _onCartItemAdded(CartItemAddedEvent event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.cartItems);
    final index = items.indexWhere((i) => i.product.id == event.product.id);

    if (index >= 0) {
      final existing = items[index];
      items[index] = existing.copyWith(quantity: existing.quantity + 1);
    } else {
      items.add(
        CartItem(
          product: event.product,
          quantity: 1,
        ),
      );
    }

    emit(CartState(cartItems: items));
  }

  void _onCartItemRemoved(CartItemRemovedEvent event, Emitter<CartState> emit) {
    final items =
        state.cartItems.where((i) => i.product.id != event.productId).toList();
    emit(CartState(cartItems: items));
  }

  void _onQtyIncreased(
      CartItemQtyIncreaseEvent event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.cartItems);
    final index = items.indexWhere((i) => i.product.id == event.productId);
    if (index < 0) return;

    final existing = items[index];
    items[index] = existing.copyWith(quantity: existing.quantity + 1);
    emit(CartState(cartItems: items));
  }

  void _onQtyDecreased(
      CartItemQtyDecreaseEvent event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.cartItems);
    final index = items.indexWhere((i) => i.product.id == event.productId);
    if (index < 0) return;

    final existing = items[index];
    final newQty = existing.quantity;

    if (newQty <= 0) {
      items.removeAt(index);
    } else {
      items[index] = existing.copyWith(quantity: newQty - 1);
    }

    emit(CartState(cartItems: items));
  }

  void _onCartClear(CartClearedEvent event, Emitter<CartState> emit) {
    emit(const CartState(cartItems: []));
  }
}
