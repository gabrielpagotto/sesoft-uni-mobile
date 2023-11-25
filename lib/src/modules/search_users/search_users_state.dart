import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_users_state.freezed.dart';

@freezed
class SearchUsersState with _$SearchUsersState {
  factory SearchUsersState({
    @Default(PageStorageKey(1)) PageStorageKey pageStorageKey,
  }) = _SearchUsersState;
}
