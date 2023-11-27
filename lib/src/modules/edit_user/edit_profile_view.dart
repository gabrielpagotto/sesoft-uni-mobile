import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesoft_uni_mobile/src/modules/edit_user/edit_profile_controller.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_elevated_button.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_profile_icon.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_scaffold.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_text_form_field.dart';

class EditProfileView extends ConsumerWidget {
  const EditProfileView({super.key});

  // ignore: constant_identifier_names
  static const ROUTE = '/edit-profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SesoftScaffold(
      titleText: 'Editar perfil',
      body: ListView(
        children: [
          SesoftProfileIcon(
            user: ref.watch(editProfileControllerProvider.select((value) => value.userEditing)),
            callProfileOnClick: false,
            size: 90,
          ),
          SesoftTextFormField(
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            labelText: 'Nome',
            controller: ref.watch(editProfileControllerProvider.select((value) => value.displayNameTextController)),
          ),
          SesoftTextFormField(
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            labelText: 'Fale sobre você',
            controller: ref.watch(editProfileControllerProvider.select((value) => value.bioTextController)),
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          const Align(child: SesoftElevatedButton(child: Text('Salvar alterações'))),
        ],
      ),
    );
  }
}
