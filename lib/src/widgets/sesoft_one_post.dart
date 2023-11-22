// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesoft_uni_mobile/src/models/post.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_post.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_profile_icon.dart';

class SesoftOnePost extends ConsumerWidget {
  SesoftOnePost({super.key, required this.post});

  final Post post;
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              children: [
                if (post.user == null) const SizedBox.shrink(),
                if (post.user != null)
                  Row(
                    children: [
                      SesoftProfileIcon(
                        user: post.user!,
                        size: 42,
                      ),
                      const SizedBox(width: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.user!.profile?.displayName ?? '',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            post.user!.username,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                const SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    post.content,
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => {},
                      icon: Icon(
                        post.userLiked == true ? Icons.favorite : Icons.favorite_border,
                        color: post.userLiked == true ? Colors.red : null,
                      ),
                      iconSize: 15,
                      padding: EdgeInsets.zero,
                    ),
                    Text(post.likesCount.toString()),
                  ],
                ),
                TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: 'Adicione um comentário',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10, bottom: 10 + MediaQuery.of(context).padding.bottom),
              itemCount: post.replies.length,
              itemBuilder: (context, index) {
                return SesoftPost(post: post.replies[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
