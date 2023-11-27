import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:sesoft_uni_mobile/src/helpers/extensions/build_context.dart';

class SesoftPostImage extends StatelessWidget {
  const SesoftPostImage({
    super.key,
    required this.file,
    this.onRemove,
  });

  final File file;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: context.theme.dividerColor),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          margin: const EdgeInsets.only(right: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GestureDetector(
              onTap: () => OpenFile.open(file.path),
              child: Image.file(
                File(file.path),
                fit: BoxFit.cover,
                width: 150,
                height: 200,
              ),
            ),
          ),
        ),
        if (onRemove != null)
          Positioned(
            top: 0,
            right: 10,
            child: IconButton.filled(
              onPressed: onRemove,
              icon: const Icon(Icons.close),
            ),
          ),
      ],
    );
  }
}
