import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sesoft_uni_mobile/src/helpers/extensions/build_context.dart';
import 'package:sesoft_uni_mobile/src/models/user.dart';
import 'package:sesoft_uni_mobile/src/modules/profile/profile_view.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_profile_icon.dart';

class SesoftUser extends StatelessWidget {
  const SesoftUser({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(ProfileView.ROUTE, extra: user.id),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SesoftProfileIcon(user: user),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.profile?.displayName ?? '',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    '@${user.username}',
                    style: TextStyle(color: context.theme.hintColor),
                  ),
                  if (user.profile?.bio != null && user.profile!.bio!.isNotEmpty)
                    Text(
                      user.profile?.bio ?? '',
                      style: context.textTheme.labelLarge,
                    ),
                  if (user.extra?.youFollow ?? false)
                    Text(
                      'Você segue',
                      style: TextStyle(color: context.theme.hintColor),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
