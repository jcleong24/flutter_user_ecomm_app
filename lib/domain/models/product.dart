import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory Product.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Product(
      id: doc.id,
      name: (data['name'] ?? '') as String,
      description: (data['description'] ?? '') as String,
      price: (data['price'] as num).toDouble(),
      stockQty: (data['stockQty'] ?? 0) as int,
      imageUrl: (data['imageUrl'] ?? '') as String,
    );
  }
}
