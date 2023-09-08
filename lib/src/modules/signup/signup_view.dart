import 'package:flutter/material.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_bottom_bar_container.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_elevated_button.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_scaffold.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_text_form_field.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  // ignore: constant_identifier_names
  static const ROUTE = '/signup';

  @override
  Widget build(BuildContext context) {
    return SesoftScaffold(
      titleText: 'Registrar-se no Sesoft Uni',
      body: ListView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0).copyWith(bottom: 50),
            child: const Text(
              'Para se cadastrar no aplicativo informe seus dados.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 29),
            ),
          ),
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
        ],
      ),
      bottomNavigationBar: SesoftBottomBarContainer(
        child: Align(
          alignment: Alignment.centerRight,
          child: SesoftElevatedButton(
            onPressed: () {},
            icon: const Icon(Icons.app_registration_outlined),
            child: const Text("Registrar-se"),
          ),
        ),
      ),
    );
  }
}
