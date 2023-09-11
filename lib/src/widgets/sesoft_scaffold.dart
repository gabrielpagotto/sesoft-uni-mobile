import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SesoftScaffold extends ConsumerWidget {
  final String? titleText;
  final Widget? body;
  final bool applyGradient;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBarBottom;

  const SesoftScaffold({super.key, this.titleText, this.body, this.applyGradient = false, this.bottomNavigationBar, this.drawer, this.floatingActionButton, this.appBarBottom});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: titleText != null
          ? AppBar(
              bottom: appBarBottom,
              title: Text(titleText!),
            )
          : null,
      body: Container(
        decoration: BoxDecoration(
          gradient: applyGradient
              ? LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  stops: const [0.1, 0.5],
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(.4),
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                )
              : null,
        ),
        child: body,
      ),
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
    );
  }
}
