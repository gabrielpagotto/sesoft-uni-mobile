import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sesoft_uni_mobile/src/modules/signin/signin_controller.dart';
import 'package:sesoft_uni_mobile/src/modules/signin/signin_validators.dart';
import 'package:sesoft_uni_mobile/src/modules/signup/signup_view.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_bottom_bar_container.dart';
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
      titleText: 'Entrar no Sesoft Uni',
      body: Form(
        key: ref.watch(signinControllerProvider.select((value) => value.formKey)),
        autovalidateMode: ref.watch(signinControllerProvider.select((value) => value.autovalidateMode)),
        child: ListView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0).copyWith(bottom: 50),
              child: const Text(
                'Sem bem vindo novamente, informe seus dados para acessar o aplicativo',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 29),
              ),
            ),
            Consumer(
              builder: (context, ref, _) => SesoftTextFormField(
                controller: ref.watch(signinControllerProvider.select((value) => value.emailTextController)),
                labelText: 'Email',
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                validator: SigninValidators.validateEmail,
              ),
            ),
            Consumer(builder: (context, ref, _) {
              return SesoftTextFormField(
                labelText: 'Senha',
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.visiblePassword,
                controller: ref.watch(signinControllerProvider.select((value) => value.passwordTextController)),
                validator: SigninValidators.validatePassword,
              );
            }),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: SesoftBottomBarContainer(
        child: Align(
          alignment: Alignment.centerRight,
          child: Consumer(
            builder: (context, ref, child) {
              return ElevatedButton.icon(
                onPressed: ref.watch(signinControllerProvider.select((value) => value.isSubmiting)) ? null : controller.submit,
                label: const Text("Entrar"),
                icon: const Icon(Icons.login),
              );
            },
          ),
        ),
      ),
    );
  }
}
