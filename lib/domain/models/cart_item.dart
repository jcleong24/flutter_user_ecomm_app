import 'package:flutter_user_ecomm_app/domain/models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get subtotal => product.price * quantity;

  void increaseQty() {
    if (quantity > 1) {
      quantity--;
    }
  }
}
