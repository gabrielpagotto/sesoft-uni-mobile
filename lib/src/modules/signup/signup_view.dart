import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesoft_uni_mobile/src/modules/signup/signup_controller.dart';
import 'package:sesoft_uni_mobile/src/modules/signup/signup_validators.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_bottom_bar_container.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_elevated_button.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_scaffold.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_text_form_field.dart';

class SignupView extends ConsumerWidget {
  const SignupView({super.key});

  // ignore: constant_identifier_names
  static const ROUTE = '/signup';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(signupControllerProvider.notifier);
    return SesoftScaffold(
      titleText: 'Registrar-se no Sesoft Uni',
      body: Form(
        key: ref.watch(signupControllerProvider.select((value) => value.formKey)),
        autovalidateMode: ref.watch(signupControllerProvider.select((value) => value.autovalidateMode)),
        child: ListView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0).copyWith(bottom: 50),
              child: const Text(
                'Para se cadastrar no aplicativo informe seus dados.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 29),
              ),
            ),
            Consumer(builder: (context, ref, _) {
              return SesoftTextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                labelText: 'Nome completo',
                controller: ref.watch(signupControllerProvider.select((value) => value.displayNameTextController)),
                validator: SignupValidators.validateDisplayName,
              );
            }),
            Consumer(builder: (context, ref, _) {
              return SesoftTextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                labelText: "Nome de usuário",
                controller: ref.watch(signupControllerProvider.select((value) => value.usernameTextController)),
                validator: SignupValidators.validateUsername,
              );
            }),
            Consumer(builder: (context, ref, _) {
              return SesoftTextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                labelText: "Email",
                controller: ref.watch(signupControllerProvider.select((value) => value.emailTextController)),
                validator: SignupValidators.validateEmail,
              );
            }),
            Consumer(builder: (context, ref, _) {
              return SesoftTextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.visiblePassword,
                labelText: "Senha",
                controller: ref.watch(signupControllerProvider.select((value) => value.passwordTextController)),
                validator: SignupValidators.validatePassword,
              );
            }),
            Consumer(builder: (context, ref, _) {
              return SesoftTextFormField(
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.visiblePassword,
                labelText: "Confirmação de senha",
                validator: (v) => SignupValidators.validatePasswordConfirmation(ref.watch(signupControllerProvider.select((value) => value.passwordTextController.text)), v),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: SesoftBottomBarContainer(
        child: Align(
          alignment: Alignment.centerRight,
          child: Consumer(builder: (context, ref, _) {
            return SesoftElevatedButton(
              onPressed: ref.watch(signupControllerProvider.select((value) => value.isSubmiting)) ? null : controller.submit,
              icon: const Icon(Icons.app_registration_outlined),
              child: const Text("Registrar-se"),
            );
          }),
        ),
      ),
    );
  }
}
