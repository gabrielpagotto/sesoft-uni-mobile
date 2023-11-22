import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class PostView extends ConsumerStatefulWidget {
  final String? postId;

  const PostView({super.key, required this.postId});

  // ignore: constant_identifier_names
  static const ROUTE = '/post';

  @override
  ConsumerState<PostView> createState() => _PostViewState();
}

class _PostViewState extends ConsumerState<PostView> {
  List<Comment> comments = [
    Comment(userName: 'Nome1', userAlias: 'nomeusuario1', text: 'Comentário 1'),
    Comment(userName: 'Nome2', userAlias: 'nomeusuario2', text: 'Comentário 2'),
    Comment(userName: 'Nome3', userAlias: 'nomeusuario3', text: 'Comentário 3'),
  ];

  TextEditingController commentController = TextEditingController();
  int likesCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicação'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAuthorHeader(),
              const SizedBox(height: 16.0),
              const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        likesCount++;
                      });
                    },
                    icon: const Icon(Icons.favorite),
                    iconSize: 19,
                    padding: EdgeInsets.zero,
                  ),
                  Text(likesCount.toString()),
                ],
              ),
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: 'Adicione um comentário',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      setState(() {
                        comments.add(
                          Comment(
                            userName: 'Seu Nome',
                            userAlias: 'seunomeusuario',
                            text: commentController.text,
                          ),
                        );
                        commentController.clear();
                      });
                    },
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

  Widget _buildAuthorHeader() {
    return const Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
          // Adicione a imagem do usuário aqui
          // backgroundImage: AssetImage('caminho/para/imagem.png'),
        ),
        SizedBox(width: 16.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Leonardo Oliveira',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            Text(
              '@leonardo',
              style: TextStyle(
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
