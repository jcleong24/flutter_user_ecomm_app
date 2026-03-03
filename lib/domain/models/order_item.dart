class OrderItem {
  final String productId; // reference to Product class
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;

  const OrderItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  double get subtotal => price * quantity;

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'name': name,
        'price': price,
        'quantity': quantity,
        'imageUrl': imageUrl,
      };

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        productId: (json['productId'] ?? '') as String,
        name: (json['name'] ?? '') as String,
        price: ((json['price'] ?? 0) as num).toDouble(),
        quantity: ((json['quantity'] ?? 0) as num).toInt(),
        imageUrl: (json['imageUrl'] ?? '') as String,
      );
}
