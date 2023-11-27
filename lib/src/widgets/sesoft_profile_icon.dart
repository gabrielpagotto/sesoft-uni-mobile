import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sesoft_uni_mobile/src/helpers/extensions/build_context.dart';
import 'package:sesoft_uni_mobile/src/models/user.dart';
import 'package:sesoft_uni_mobile/src/modules/profile/profile_view.dart';

class SesoftProfileIcon extends StatelessWidget {
  const SesoftProfileIcon({
    super.key,
    required this.user,
    this.size = 35,
    this.callProfileOnClick = true,
    this.onTap,
  });

  final User user;
  final bool callProfileOnClick;
  final double size;
  final VoidCallback? onTap;

  void goToProfile(BuildContext context) {
    onTap?.call();
    if (user.id.isEmpty) {
      return;
    }
    if (!callProfileOnClick) {
      return;
    }
    if (Scaffold.of(context).isDrawerOpen) {
      Scaffold.of(context).closeDrawer();
    }
    context.push(ProfileView.ROUTE, extra: user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: Material(
        shape: const CircleBorder(),
        borderOnForeground: false,
        child: GestureDetector(
          onTap: () => goToProfile(context),
          child: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            width: size * 1.2,
            height: size * 1.2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: context.theme.dividerColor),
            ),
            child: user.profile?.icon?.url != null
                ? Image.network(
                    user.profile!.icon!.url!,
                    fit: BoxFit.cover,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Icon(Icons.person, size: size),
                  ),
          ),
        ),
      ),
    );
  }
}
