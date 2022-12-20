import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  int tabletPadding;
  int desktopPadding;

  ResponsiveLayout({
    required this.mobileBody,
    required this.tabletPadding,
    required this.desktopPadding,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          return mobileBody;
        } else if (constraints.maxWidth < 1100) {
          return ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: mobileBody,
          );
        } else {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
              child: mobileBody,
            ),
          );
        }
      },
    );
  }
}
