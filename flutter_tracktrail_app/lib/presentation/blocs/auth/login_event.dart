import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  LoginButtonPressed({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LoginNormalButtonPressed extends LoginEvent {
  final String email;
  final String password;

  LoginNormalButtonPressed({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class RegisterButtonPressed extends LoginEvent {
  final String email;
  final String password;

  RegisterButtonPressed({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LogoutButtonPressed extends LoginEvent {}

class CheckAuthentication extends LoginEvent {}

class ToggleRegisterMode extends LoginEvent {}

class ResetPasswordButtonPressed extends LoginEvent {
  final String email;

  ResetPasswordButtonPressed({required this.email});

  @override
  List<Object?> get props => [email];
}

class UpdateUserDataEvent extends LoginEvent {
  final String email;
  final String? name;
  final String? surname;
  final String? password;
  final double? weight;
  final DateTime? dateOfBirth;
  final String? sex;
  final double? height;
  final String? avatar;

  UpdateUserDataEvent({
    required this.email,
    this.name,
    this.surname,
    this.password,
    this.weight,
    this.dateOfBirth,
    this.sex,
    this.height,
    this.avatar,
  });

  @override
  List<Object?> get props => [
        email,
        name,
        surname,
        password,
        weight,
        dateOfBirth,
        sex,
        height,
        avatar
      ];
}
