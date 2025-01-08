import 'package:flutter_tracktrail_app/domain/entities/user_database_entity.dart';

class UserDatabaseModel {
  final int idUser;
  final String? name;
  final String? surname;
  final String email;
  final int? weight;
  final DateTime? dateOfBirth;
  final String? sex;
  final int? height;
  final int? role;

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
  });

  factory UserDatabaseModel.fromJson(Map<String, dynamic> json) {
    return UserDatabaseModel(
      idUser: json['id_user'],
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
      weight: json['weight'],
      dateOfBirth: json['dateofbirth'] != null
          ? DateTime.parse(json['dateofbirth'])
          : null,
      sex: json['sex'],
      height: json['height'],
      role: json['role'],
    );
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
    };
  }

  UserDatabaseEntity toEntity() {
    return UserDatabaseEntity(
      id: idUser,
      name: name ?? '',
      surname: surname ?? '',
      email: email,
      password: '',
      weight: weight?.toDouble() ?? 0.0,
      dateOfBirth: dateOfBirth ?? DateTime(1900, 1, 1),
      sex: sex ?? '',
      height: height?.toDouble() ?? 0.0,
      role: role ?? 0,
    );
  }
}
