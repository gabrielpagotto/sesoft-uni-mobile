import 'package:flutter/material.dart';
import 'package:sesoft_uni_mobile/src/helpers/extensions/build_context.dart';
import 'package:sesoft_uni_mobile/src/models/user.dart';

class SesoftProfileIcon extends StatelessWidget {
  const SesoftProfileIcon({super.key, required this.user, this.size = 35, this.callProfileOnClick = false});

  final User user;
  final bool callProfileOnClick;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: context.theme.dividerColor),
      ),
      child: Icon(Icons.person, size: size),
    );
  }
}
