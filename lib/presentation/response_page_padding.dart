import 'package:flutter/material.dart';

class ResponsivePagePadding extends StatelessWidget {
  final Widget child;

  const ResponsivePagePadding({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        double start = 20;
        double top = 35;
        double end = 20;
        double bottom = 0;
        double maxWidth = 430;

        if (width >= 600) {
          start = 28;
          top = 66;
          maxWidth = 600;
        }

        if (width >= 900) {
          start = 36;
          top = 58;
          maxWidth = 720;
        }

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                start,
                top,
                end,
                bottom,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
