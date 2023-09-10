import 'package:flutter/material.dart';

mixin StatefulValueNotifierObserver<T extends StatefulWidget> on State<T> {
  List<ValueNotifier> get notifiers;

  @override
  void initState() {
    for (final notifier in notifiers) {
      notifier.addListener(() {
        setState(() {});
      });
    }
    super.initState();
  }
}
