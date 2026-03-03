import '../models/cart_item.dart';
import '../models/order_item.dart';

OrderItem toOrderItem(CartItem cartItem) {
  final p = cartItem.product;

  return OrderItem(
    productId: p.id,
    name: p.name,
    price: p.price,
    quantity: cartItem.quantity,
    imageUrl: p.imageUrl,
  );
}
