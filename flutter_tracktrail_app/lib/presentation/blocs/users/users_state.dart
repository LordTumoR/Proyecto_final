import 'package:flutter_tracktrail_app/domain/entities/user_database_entity.dart';

class UserState {
  final UserDatabaseEntity user;
  final String error;
  final bool isLoading;

  UserState({
    required this.user,
    required this.error,
    required this.isLoading,
  });

  factory UserState.initial() {
    return UserState(
      user: UserDatabaseEntity(
        id: 0,
        name: '',
        surname: '',
        email: '',
        password: '',
        weight: 0.0,
        dateOfBirth: DateTime(1900, 1, 1),
        sex: '',
        height: 0.0,
        role: 0,
        avatar: '',
      ),
      error: '',
      isLoading: false,
    );
  }

  factory UserState.loading() {
    return UserState(
      user: UserDatabaseEntity(
        id: 0,
        name: '',
        surname: '',
        email: '',
        password: '',
        weight: 0.0,
        dateOfBirth: DateTime(1900, 1, 1),
        sex: '',
        height: 0.0,
        role: 0,
        avatar: '',
      ),
      error: '',
      isLoading: true,
    );
  }

  factory UserState.success(UserDatabaseEntity user) {
    return UserState(
      user: user,
      error: '',
      isLoading: false,
    );
  }

  factory UserState.failure(String error) {
    return UserState(
      user: UserDatabaseEntity(
        id: 0,
        name: '',
        surname: '',
        email: '',
        password: '',
        weight: 0.0,
        dateOfBirth: DateTime(1900, 1, 1),
        sex: '',
        height: 0.0,
        role: 0,
        avatar: '',
      ),
      error: error,
      isLoading: false,
    );
  }
}
