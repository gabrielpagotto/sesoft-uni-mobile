import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sesoft_uni_mobile/src/annotations/model.dart';
import 'package:sesoft_uni_mobile/src/models/user.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@model
class Post with _$Post {
  const factory Post({
    required String id,
    required String content,
    required int likesCount,
    required int repliesCount,
    User? user,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Post;

  factory Post.fromJson(Map<String, Object?> json) => _$PostFromJson(json);
}
