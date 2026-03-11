import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routers/route_name.dart';
import '../../../core/theme/style_manager.dart';

class HomeHeaderSub extends StatelessWidget {
  final String title;

  const HomeHeaderSub({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: StyleManager.headingExtraSmall(),
        ),
        InkWell(
          onTap: () {
            context.push(RouteNames.home);
          },
          child: Text(
            'See All',
            style: StyleManager.caption(),
          ),
        ),
      ],
    );
  }
}
