// ignore_for_file: public_member_api_docs, sort_constructors_first
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
    @Default(0) int likesCount,
    int? repliesCount, // TODO: Colocar como requerido quando a API for atualizada
    User? user,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(false) bool liked,
    @Default(false) bool? userLiked,
    @Default([]) List<Post> replies,
  }) = _Post;

  factory Post.fromJson(Map<String, Object?> json) => _$PostFromJson(json);
}
