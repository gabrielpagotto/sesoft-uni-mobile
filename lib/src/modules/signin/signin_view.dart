import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sesoft_uni_mobile/src/modules/signin/signin_controller.dart';
import 'package:sesoft_uni_mobile/src/modules/signup/signup_view.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_logo.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_scaffold.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_text_form_field.dart';

class SigninView extends ConsumerWidget {
  const SigninView({super.key});

  // ignore: constant_identifier_names
  static const ROUTE = '/signin';

  goToSignup(BuildContext context) {
    context.push(SignupView.ROUTE);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(signinControllerProvider.notifier);
    return SesoftScaffold(
      titleText: 'Bem vindo ao Sesoft Uni',
      body: ListView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        children: [
          const SesoftLogo(),
          const SesoftTextFormField(
            labelText: 'Email',
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
          ),
          const SesoftTextFormField(
            labelText: 'Senha',
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.visiblePassword,
          ),
          const SizedBox(height: 30),
          Align(
            child: Consumer(
              builder: (context, ref, child) {
                return ElevatedButton.icon(
                  onPressed: controller.submit,
                  label: const Text("Entrar"),
                  icon: const Icon(Icons.login),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Align(
            child: TextButton.icon(
              onPressed: () => goToSignup(context),
              label: const Text("Registre-se"),
              icon: const Icon(Icons.app_registration_rounded),
            ),
          )
        ],
      ),
    );
  }
}
