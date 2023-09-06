import 'package:flutter/material.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_elevated_button.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_logo.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_scaffold.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_text_form_field.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  // ignore: constant_identifier_names
  static const ROUTE = '/signup';

  @override
  Widget build(BuildContext context) {
    return SesoftScaffold(
      titleText: 'Cadastrar-se',
      body: ListView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        children: [
          const SesoftLogo(),
          const SesoftTextFormField(
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            labelText: 'Nome completo',
          ),
          const SesoftTextFormField(
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            labelText: "Nome de usuário",
          ),
          const SesoftTextFormField(
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            labelText: "Email",
          ),
          const SesoftTextFormField(
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.visiblePassword,
            labelText: "Senha",
          ),
          const SesoftTextFormField(
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.visiblePassword,
            labelText: "Confirmação de senha",
          ),
          const SizedBox(height: 30),
          Align(
            child: SesoftElevatedButton(
              onPressed: () {},
              icon: const Icon(Icons.app_registration_outlined),
              child: const Text("Registrar-se"),
            ),
          )
        ],
      ),
    );
  }
}
