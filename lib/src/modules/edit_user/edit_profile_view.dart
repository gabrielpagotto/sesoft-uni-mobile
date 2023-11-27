import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.outlined(
                onPressed: () => ref.read(editProfileControllerProvider.notifier).changeProfileImage(ImageSource.camera),
                icon: const Icon(Icons.camera_outlined),
              ),
              IconButton.outlined(
                onPressed: () => ref.read(editProfileControllerProvider.notifier).changeProfileImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_camera_back_outlined),
              )
            ],
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
          Consumer(builder: (context, ref, _) {
            final disabled = ref.watch(editProfileControllerProvider.select((value) => !value.hasChanges || value.isSubmiting));
            return Align(
              child: SesoftElevatedButton(
                onPressed: disabled ? null : ref.read(editProfileControllerProvider.notifier).submit,
                child: const Text('Salvar alterações'),
              ),
            );
          }),
        ],
      ),
    );
  }
}
