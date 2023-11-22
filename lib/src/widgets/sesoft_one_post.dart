// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesoft_uni_mobile/src/models/post.dart';
import 'package:sesoft_uni_mobile/src/models/user.dart';

class Comment {
  final String userName;
  final String userAlias;
  final String text;

  Comment({
    required this.userName,
    required this.userAlias,
    required this.text,
  });
}

class SesoftOnePost extends ConsumerWidget {
  SesoftOnePost({super.key, required this.post});

  final Post post;

  List<Comment> comments = [
    Comment(userName: 'Nome1', userAlias: 'nomeusuario1', text: 'Comentário 1'),
    Comment(userName: 'Nome2', userAlias: 'nomeusuario2', text: 'Comentário 2'),
    Comment(userName: 'Nome3', userAlias: 'nomeusuario3', text: 'Comentário 3'),
  ];

  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAuthorHeader(post.user),
              const SizedBox(height: 16.0),
              Text(
                post.content,
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  IconButton(
                    onPressed: () => {},
                    icon: Icon(
                      post.userLiked == true
                          ? Icons.favorite
                          : Icons.favorite_border,
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
              const SizedBox(height: 13.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.grey,
                    ),
                    title: Text(
                        '${comments[index].userName} @${comments[index].userAlias}'),
                    subtitle: Text(comments[index].text),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthorHeader(User? user) {
    if (user == null) {
      return const SizedBox.shrink();
    }
    return Row(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
        ),
        const SizedBox(width: 16.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.profile?.displayName ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            Text(
              user.username,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
