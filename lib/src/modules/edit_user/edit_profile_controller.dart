import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/modules/edit_user/edit_profile_state.dart';
import 'package:sesoft_uni_mobile/src/services/auth_service.dart';

part 'edit_profile_controller.g.dart';

@riverpod
class EditProfileController extends _$EditProfileController {
  @override
  EditProfileState build() {
    final currentUser = ref.watch(authServiceProvider.select((value) => value.currentUser));
    return EditProfileState(
      userEditing: currentUser!.copyWith(),
      displayNameTextController: TextEditingController(text: currentUser.profile?.displayName ?? ''),
      bioTextController: TextEditingController(text: currentUser.profile?.bio ?? ''),
    );
  }
}
