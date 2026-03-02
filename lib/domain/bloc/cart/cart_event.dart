import 'package:equatable/equatable.dart';

import '../../models/product.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CartItemAddedEvent extends CartEvent {
  final Product product;

  const CartItemAddedEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class CartItemRemovedEvent extends CartEvent {
  final Product productId;

  const CartItemRemovedEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

class CartItemQtyIncreaseEvent extends CartEvent {
  final Product productId;

  const CartItemQtyIncreaseEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

class CartItemQtyDecreaseEvent extends CartEvent {
  final Product productId;

  const CartItemQtyDecreaseEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

class CartClearedEvent extends CartEvent {
  const CartClearedEvent();
}
