import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/exceptions/service_exception.dart';
import 'package:sesoft_uni_mobile/src/helpers/utils/snackbar.dart';
import 'package:sesoft_uni_mobile/src/modules/edit_user/edit_profile_state.dart';
import 'package:sesoft_uni_mobile/src/modules/profile/profile_view.dart';
import 'package:sesoft_uni_mobile/src/services/auth_service.dart';
import 'package:sesoft_uni_mobile/src/services/profile_service.dart';
import 'package:sesoft_uni_mobile/src/settings/router.dart';

part 'edit_profile_controller.g.dart';

@riverpod
class EditProfileController extends _$EditProfileController {
  @override
  EditProfileState build() {
    final currentUser = ref.watch(authServiceProvider.select((value) => value.currentUser));
    final displayNameTextController = TextEditingController(text: currentUser!.profile?.displayName ?? '')..addListener(_checkForm);
    final bioTextController = TextEditingController(text: currentUser.profile?.bio ?? '')..addListener(_checkForm);
    return EditProfileState(
      userEditing: currentUser.copyWith(),
      displayNameTextController: displayNameTextController,
      bioTextController: bioTextController,
    );
  }

  ProfileService get postsService => ref.read(profileServiceProvider.notifier);

  void _checkForm() {
    if ((state.userEditing.profile?.displayName ?? '') != state.displayNameTextController.text) {
      state = state.copyWith(hasChanges: true);
      return;
    }
    if ((state.userEditing.profile?.bio ?? '') != state.bioTextController.text) {
      state = state.copyWith(hasChanges: true);
      return;
    }
    state = state.copyWith(hasChanges: false);
  }

  Future<void> submit() async {
    try {
      state = state.copyWith(isSubmiting: true);
      await postsService.updateMe(state.userEditing.profile!.copyWith(
        displayName: state.displayNameTextController.text,
        bio: state.bioTextController.text,
      ));
      await ref.read(authServiceProvider.notifier).verifyAuth();
      ref.invalidate(getUserProfileViewProvider);
      ref.invalidate(getPostsProfileViewProvider);
      ref.invalidate(getLikedPostsProfileViewProvider);
      SesoftSnackbar.success('Perfil foi atualizado com sucesso.');
      router.pop();
    } on ServiceException catch (err) {
      SesoftSnackbar.error(err.message);
    } finally {
      state = state.copyWith(isSubmiting: false);
    }
  }

  Future<void> changeProfileImage(ImageSource source) async {
    late final PermissionStatus permissionStatus;
    if (source == ImageSource.camera) {
      permissionStatus = await Permission.camera.request();
    } else if (source == ImageSource.gallery) {
      permissionStatus = await Permission.photos.request();
    }
    if (permissionStatus.isDenied) {
      return;
    }
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source);
    if (file != null) {
      state = state.copyWith(updatingProfileIcon: true);
      try {
        final icon = await ref.read(profileServiceProvider.notifier).updateProfileImage(File(file.path));
        final profile = state.userEditing.profile!.copyWith(icon: icon);
        final user = state.userEditing.copyWith(profile: profile);
        state = state.copyWith(userEditing: user);
        await ref.read(authServiceProvider.notifier).verifyAuth();
        ref.invalidate(getUserProfileViewProvider);
        ref.invalidate(getPostsProfileViewProvider);
        ref.invalidate(getLikedPostsProfileViewProvider);
      } catch (_) {
        SesoftSnackbar.error('Não foi possível atualizar a foto de perfil');
      } finally {
        state = state.copyWith(updatingProfileIcon: false);
      }
    }
  }
}
