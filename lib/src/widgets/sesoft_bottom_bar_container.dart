import 'package:flutter/material.dart';

class SesoftBottomBarContainer extends StatelessWidget {
  final Widget child;

  const SesoftBottomBarContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom,
        top: 5,
        right: 5,
      ),
      height: 100,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: child,
    );
  }
}
