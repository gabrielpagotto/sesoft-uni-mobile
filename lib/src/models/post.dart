// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sesoft_uni_mobile/src/annotations/model.dart';
import 'package:sesoft_uni_mobile/src/models/storage.dart';
import 'package:sesoft_uni_mobile/src/models/user.dart';

part 'post.freezed.dart';
part 'post.g.dart';

Object? _readValueFiles(Map<dynamic, dynamic> data, String key) {
  final files = data[key];
  if (files is List) {
    final items = files.map((e) => e['storage']).toList();
    return items;
  }
  return [];
}

@model
class Post with _$Post {
  const factory Post({
    required String id,
    required String content,
    @Default(0) int likesCount,
    @Default(0) int repliesCount,
    User? user,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(false) bool liked,
    bool? userLiked,
    @Default([]) List<Post> replies,
    // ignore: invalid_annotation_target
    @JsonKey(readValue: _readValueFiles) @Default([]) List<Storage> files,
  }) = _Post;

  factory Post.fromJson(Map<String, Object?> json) => _$PostFromJson(json);
}
