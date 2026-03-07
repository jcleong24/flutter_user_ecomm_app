import 'package:flutter/material.dart';
import 'package:flutter_user_ecomm_app/core/theme/color_manager.dart';
import 'package:flutter_user_ecomm_app/core/theme/style_manager.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onSearchPressed;

  const HomeSearchBar({
    super.key,
    this.onTap,
    this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorManager.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
              child: IconButton(
                icon: const Icon(Icons.search),
                color: ColorManager.primary,
                onPressed: onSearchPressed,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
              child: Text(
                'Search',
                style: StyleManager.caption(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
