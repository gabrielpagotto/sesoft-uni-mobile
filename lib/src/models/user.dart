import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sesoft_uni_mobile/src/annotations/model.dart';
import 'package:sesoft_uni_mobile/src/models/profile.dart';
import 'package:sesoft_uni_mobile/src/models/user_extra.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@model
class User with _$User {
  const factory User({
    required String id,
    required String username,
    required String? email,
    int? followingsCount,
    int? followersCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    Profile? profile,
    UserExtra? extra,
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
