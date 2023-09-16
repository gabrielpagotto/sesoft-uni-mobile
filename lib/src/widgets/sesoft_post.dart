import 'package:flutter/material.dart';
import 'package:sesoft_uni_mobile/src/helpers/extensions/build_context.dart';
import 'package:sesoft_uni_mobile/src/models/post.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_profile_icon.dart';

class SesoftPost extends StatelessWidget {
  const SesoftPost({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.only(top: 10, right: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SesoftProfileIcon(user: post.user!),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          post.user!.profile!.displayName,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "@${post.user!.username}",
                          style: context.textTheme.titleSmall?.copyWith(color: context.theme.colorScheme.outline),
                        ),
                      ],
                    ),
                    Text(
                      post.content,
                      style: context.textTheme.bodyLarge?.copyWith(),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.mode_comment),
                              iconSize: 15,
                              padding: EdgeInsets.zero,
                            ),
                            Text(post.likesCount.toString()),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.favorite),
                              iconSize: 15,
                              padding: EdgeInsets.zero,
                            ),
                            Text(post.likesCount.toString()),
                          ],
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.ios_share),
                          iconSize: 15,
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
