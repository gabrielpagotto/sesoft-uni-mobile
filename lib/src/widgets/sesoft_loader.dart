import 'package:flutter/material.dart';
import 'package:sesoft_uni_mobile/src/helpers/extensions/build_context.dart';

class SesoftLoader extends StatelessWidget {
  const SesoftLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator.adaptive(),
          const SizedBox(height: 10),
          Text('CARREGANDO...', style: context.textTheme.labelSmall),
        ],
      ),
    );
  }
}
