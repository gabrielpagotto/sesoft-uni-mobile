import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sesoft_uni_mobile/src/annotations/model.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@model
class Profile with _$Profile {
  const factory Profile({
    required String? id,
    required String displayName,
    String? bio,
    String? icon,
  }) = _Profile;

  factory Profile.fromJson(Map<String, Object?> json) => _$ProfileFromJson(json);
}
