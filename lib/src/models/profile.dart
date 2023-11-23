import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sesoft_uni_mobile/src/annotations/model.dart';
import 'package:sesoft_uni_mobile/src/models/storage.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@model
class Profile with _$Profile {
  const factory Profile({
    required String? id,
    required String displayName,
    String? bio,
    Storage? icon,
  }) = _Profile;

  factory Profile.fromJson(Map<String, Object?> json) => _$ProfileFromJson(json);
}
