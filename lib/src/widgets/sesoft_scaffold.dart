import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SesoftScaffold extends ConsumerWidget {
  final String titleText;
  final Widget? body;
  final bool applyGradient;

  const SesoftScaffold({
    super.key,
    required this.titleText,
    this.body,
    this.applyGradient = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: Theme.of(context).brightness == Brightness.light ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        bottom: const PreferredSize(preferredSize: Size.fromHeight(0), child: Divider(height: 0)),
        title: Text(
          titleText,
          style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
        ),
      ),
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
    );
  }
}