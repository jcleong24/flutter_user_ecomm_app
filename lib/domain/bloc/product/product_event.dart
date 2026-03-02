import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class ProductRequested extends ProductEvent {
  const ProductRequested();
}

class ProductRefreshed extends ProductEvent {
  const ProductRefreshed();
}

class ProductDetailsRequested extends ProductEvent {
  final String productId;

  const ProductDetailsRequested(this.productId);

  @override
  List<Object?> get props => [productId];
}
