import 'package:flutter_tracktrail_app/domain/entities/user_database_entity.dart';

class UserDatabaseModel {
  final int idUser;
  final String? name;
  final String? surname;
  final String email;
  final double? weight;
  final DateTime? dateOfBirth;
  final String? sex;
  final double? height;
  final double? role;
  final String? avatar;

  UserDatabaseModel({
    required this.idUser,
    this.name,
    this.surname,
    required this.email,
    this.weight,
    this.dateOfBirth,
    this.sex,
    this.height,
    this.role,
    this.avatar,
  });

  factory UserDatabaseModel.fromJson(Map<String, dynamic> json) {
    return UserDatabaseModel(
        idUser: json['id_user'],
        name: json['name'],
        surname: json['surname'],
        email: json['email'],
        weight: (json['weight'] is int)
            ? (json['weight'] as int).toDouble()
            : json['weight'],
        dateOfBirth: json['dateofbirth'] != null
            ? DateTime.tryParse(json['dateofbirth']) ?? DateTime(1900)
            : null,
        sex: json['sex'],
        height: json['height'],
        role: (json['role'] is int)
            ? (json['role'] as int).toDouble()
            : json['role'],
        avatar: json['avatar']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'name': name,
      'surname': surname,
      'email': email,
      'weight': weight,
      'dateofbirth': dateOfBirth?.toIso8601String(),
      'sex': sex,
      'height': height,
      'role': role,
      'avatar': avatar,
    };
  }

  UserDatabaseEntity toEntity() {
    return UserDatabaseEntity(
      id: idUser,
      name: name ?? '',
      surname: surname ?? '',
      email: email,
      password: '',
      weight: weight ?? 0.0,
      dateOfBirth: dateOfBirth ?? DateTime(1900, 1, 1),
      sex: sex ?? '',
      height: height ?? 0.0,
      role: role ?? 0.0,
      avatar: avatar ?? '',
    );
  }
}
