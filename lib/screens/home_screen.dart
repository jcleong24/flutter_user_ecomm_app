import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/routers/route_name.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: Center(
          child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Product $index"),
            onTap: () {
              context.go('${RouteNames.productDetails}/$index');
            },
          );
        },
      )),
    );
  }
}
