import 'dart:io';

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/clients/sesoft_client.dart';
import 'package:sesoft_uni_mobile/src/models/profile.dart';
import 'package:sesoft_uni_mobile/src/models/storage.dart';

part 'profile_service.freezed.dart';
part 'profile_service.g.dart';

@freezed
class ProfileServiceState with _$ProfileServiceState {
  factory ProfileServiceState() = _ProfileServiceState;
}

@Riverpod(dependencies: [sesoftClient])
class ProfileService extends _$ProfileService {
  @override
  ProfileServiceState build() => ProfileServiceState();

  Future<Profile> updateMe(Profile profile) async {
    final client = ref.watch(sesoftClientProvider);
    final response = await client.patch('/profile/me', data: {
      'displayName': profile.displayName,
      'bio': profile.bio,
    });
    return Profile.fromJson(response.data);
  }

  Future<Storage> updateProfileImage(File file) async {
    final client = ref.read(sesoftClientProvider);
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
    });
    final response = await client.post('/users/upload', data: formData);
    return Storage.fromJson(response.data['profile']['icon']);
  }
}
