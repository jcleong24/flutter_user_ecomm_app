import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchProducts();
}

class FirebaseProductRepository implements ProductRepository {
  final FirebaseFirestore firestore;

  FirebaseProductRepository(this.firestore);

  @override
  Future<List<Product>> fetchProducts() async {
    final snapshot = await firestore
        .collection('products')
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map(Product.fromFirestore).toList();
  }
}
