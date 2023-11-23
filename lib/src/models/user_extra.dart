import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sesoft_uni_mobile/src/annotations/model.dart';

part 'user_extra.freezed.dart';
part 'user_extra.g.dart';

@model
class UserExtra with _$UserExtra {
  const factory UserExtra({
    @Default(false) bool youFollow,
    @Default(false) bool follingYou,
  }) = _UserExtra;

  factory UserExtra.fromJson(Map<String, Object?> json) => _$UserExtraFromJson(json);
}
