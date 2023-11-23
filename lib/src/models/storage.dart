import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sesoft_uni_mobile/src/annotations/model.dart';

part 'storage.freezed.dart';
part 'storage.g.dart';

@model
class Storage with _$Storage {
  const factory Storage({required String? id, required String? url}) = _Storage;

  factory Storage.fromJson(Map<String, Object?> json) => _$StorageFromJson(json);
}
