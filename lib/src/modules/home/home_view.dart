import 'package:flutter/material.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_scaffold.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  // ignore: constant_identifier_names
  static const ROUTE = '/home';

  @override
  Widget build(BuildContext context) {
    return const SesoftScaffold(
      titleText: 'Sesoft Uni',
    );
  }
}
