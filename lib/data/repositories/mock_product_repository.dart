// import '../../domain/models/product.dart';
// import 'product_repository.dart';

// class MockProductRepository implements ProductRepository {
//   @override
//   Future<List<Product>> fetchProducts() async {
//     await Future.delayed(const Duration(seconds: 1));

//     return const [
//       Product(
//         id: '101',
//         name: 'Nike Air Max',
//         description: 'Comfortable running shoes',
//         price: 399.0,
//         stockQty: 12,
//         imageUrl: 'https://picsum.photos/300?1',
//       ),
//       Product(
//         id: '102',
//         name: 'Leather Bag',
//         description: 'Premium daily carry bag',
//         price: 259.0,
//         stockQty: 5,
//         imageUrl: 'https://picsum.photos/300?2',
//       ),
//       Product(
//         id: '103',
//         name: 'Running Shoes',
//         description: 'Lightweight running shoes',
//         price: 499.0,
//         stockQty: 8,
//         imageUrl: 'https://picsum.photos/300?3',
//       ),
//     ];
//   }
  
//   @override
//   Future<Product> fetchProductById(String id) {
//     // TODO: implement fetchProductById
//     throw UnimplementedError();
//   }
// }
