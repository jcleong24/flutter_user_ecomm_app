import 'package:equatable/equatable.dart';
import '../../models/product.dart';

enum ProductStatus { initial, onLoading, onLoaded, error }

class ProductState extends Equatable {
  final ProductStatus status;
  final List<Product> products;
  final String? errorMessage;

  final Product? selectedProduct;
  final String? selectedProductErrorMsg;
  final ProductStatus selectedProductStatus;

  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.errorMessage = '',
    this.selectedProduct,
    this.selectedProductErrorMsg,
    this.selectedProductStatus = ProductStatus.initial,
  });

  ProductState copyWith({
    ProductStatus? status,
    List<Product>? products,
    String? errorMessage,
    ProductStatus? selectedProductStatus,
    Product? selectedProduct,
    String? selectedProductErrorMsg,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedProductStatus:
          selectedProductStatus ?? this.selectedProductStatus,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      selectedProductErrorMsg:
          selectedProductErrorMsg ?? this.selectedProductErrorMsg,
    );
  }

  @override
  List<Object?> get props => [
        status,
        products,
        errorMessage,
        selectedProductStatus,
        selectedProduct,
        selectedProductErrorMsg,
      ];
}
