import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routers/route_name.dart';
import '../../../domain/bloc/cart/cart_bloc.dart';
import '../../../domain/bloc/cart/cart_state.dart';

class CartIconButton extends StatelessWidget {
  final Color iconColor;

  const CartIconButton({super.key, this.iconColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      final count = state.totalQuantity;

      return Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.35), // background color
                shape: BoxShape.circle, // circular background
              ),
              child: IconButton(
                onPressed: () {
                  context.push(RouteNames.cart);
                },
                icon: Icon(Icons.shopping_cart_outlined, color: iconColor),
              ),
            ),
          ),
          if (count > 0)
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                // padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle),
                constraints: const BoxConstraints(minHeight: 15, minWidth: 15),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
        ],
      );
    });
  }
}
