import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sesoft_uni_mobile/src/modules/signup/signup_view.dart';

class SigninView extends StatelessWidget {
  const SigninView({super.key});

  // ignore: constant_identifier_names
  static const ROUTE = '/signin';

  goToSignup(BuildContext context) {
    context.push(SignupView.ROUTE);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sesoft Uni'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          TextFormField(decoration: const InputDecoration(labelText: "Username")),
          TextFormField(decoration: const InputDecoration(labelText: "Senha")),
          ElevatedButton(onPressed: () {}, child: const Text("Entrar")),
          TextButton(onPressed: () => goToSignup(context), child: const Text("Cadastrar-se"))
        ],
      ),
    );
  }
}
