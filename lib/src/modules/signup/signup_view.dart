import 'package:flutter/material.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  // ignore: constant_identifier_names
  static const ROUTE = '/signup';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sesoft Uni'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          TextFormField(decoration: const InputDecoration(labelText: "Nome")),
          TextFormField(decoration: const InputDecoration(labelText: "Nome de usuário")),
          TextFormField(decoration: const InputDecoration(labelText: "Email")),
          TextFormField(decoration: const InputDecoration(labelText: "Senha")),
          ElevatedButton(onPressed: () {}, child: const Text("Cadastrar"))
        ],
      ),
    );
  }
}
