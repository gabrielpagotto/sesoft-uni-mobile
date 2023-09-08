import 'package:flutter/material.dart';
import 'package:sesoft_uni_mobile/src/constants/assets.dart';

class SesoftLogo extends StatelessWidget {
  const SesoftLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'sesoft_logo',
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(50),
        child: ColorFiltered(
          colorFilter: Theme.of(context).colorScheme.brightness == Brightness.dark
              ? const ColorFilter.matrix(<double>[
                  -1.0, 0.0, 0.0, 0.0, 255.0, //
                  0.0, -1.0, 0.0, 0.0, 255.0, //
                  0.0, 0.0, -1.0, 0.0, 255.0, //
                  0.0, 0.0, 0.0, 1.0, 0.0, //
                ])
              : const ColorFilter.matrix(<double>[
                  1.0, 0.0, 0.0, 0.0, 0.0, //
                  0.0, 1.0, 0.0, 0.0, 0.0, //
                  0.0, 0.0, 1.0, 0.0, 0.0, //
                  0.0, 0.0, 0.0, 1.0, 0.0, //
                ]),
          child: Image.asset(ASSET_IMAGE.logoFasoft.uri),
        ),
      ),
    );
  }
}
