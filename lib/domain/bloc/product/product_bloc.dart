import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc({required this.productRepository}) : super(const ProductState()) {
    on<ProductRequested>(_onProductRequested);
    on<ProductRefreshed>(_onProductRequested);
    on<ProductDetailsRequested>(_onProductDetailsRequested);
  }

  Future<void> _onProductRequested(
    ProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(status: ProductStatus.onLoading, errorMessage: null));

    try {
      final products = await productRepository.fetchProducts();
      emit(state.copyWith(
        status: ProductStatus.onLoaded,
        products: products,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProductStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onProductDetailsRequested(
    ProductDetailsRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(
      selectedProductStatus: ProductStatus.onLoading,
      selectedProductErrorMsg: null,
    ));

    try {
      final product = await productRepository.fetchProductById(event.productId);
      emit(state.copyWith(
        selectedProductStatus: ProductStatus.onLoaded,
        selectedProduct: product,
      ));
    } catch (e) {
      emit(state.copyWith(
        selectedProductStatus: ProductStatus.error,
        selectedProductErrorMsg: e.toString(),
      ));
    }
  }
}
