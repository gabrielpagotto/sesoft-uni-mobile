import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sesoft_uni_mobile/src/modules/signin/signin_view.dart';
import 'package:sesoft_uni_mobile/src/modules/signup/signup_view.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_logo.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_scaffold.dart';

class PresentationView extends StatelessWidget {
  const PresentationView({super.key});

  // ignore: constant_identifier_names
  static const ROUTE = '/presentation';

  @override
  Widget build(BuildContext context) {
    return SesoftScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SesoftLogo(),
          ElevatedButton.icon(
            onPressed: () => context.push(SigninView.ROUTE),
            label: const Text("Entrar"),
            icon: const Icon(Icons.login),
          ),
          const SizedBox(height: 10),
          Align(
            child: TextButton.icon(
              onPressed: () => context.push(SignupView.ROUTE),
              label: const Text("Registre-se"),
              icon: const Icon(Icons.app_registration_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
