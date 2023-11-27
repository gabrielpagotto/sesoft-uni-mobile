import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sesoft_uni_mobile/src/models/user.dart';

part 'edit_profile_state.freezed.dart';

@freezed
class EditProfileState with _$EditProfileState {
  factory EditProfileState({
    required TextEditingController displayNameTextController,
    required TextEditingController bioTextController,
    required User userEditing,
    @Default(false) bool hasChanges,
    @Default(false) bool isSubmiting,
    @Default(false) bool updatingProfileIcon,
  }) = _EditProfileState;
}
