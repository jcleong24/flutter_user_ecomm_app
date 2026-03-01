class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int stockQty;
  final String imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stockQty,
    required this.imageUrl,
  });

  bool get isOutOfStock => stockQty <= 0;
}
