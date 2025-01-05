class UserDatabaseModel {
  final int idUser;
  final String name;
  final String surname;
  final String email;
  final int weight;
  final DateTime dateOfBirth;
  final String sex;
  final int height;
  final int role;

  UserDatabaseModel({
    required this.idUser,
    required this.name,
    required this.surname,
    required this.email,
    required this.weight,
    required this.dateOfBirth,
    required this.sex,
    required this.height,
    required this.role,
  });

  factory UserDatabaseModel.fromJson(Map<String, dynamic> json) {
    return UserDatabaseModel(
      idUser: json['id_user'],
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
      weight: json['weight'],
      dateOfBirth: DateTime.parse(json['dateofbirth']),
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
      'dateofbirth': dateOfBirth.toIso8601String(),
      'sex': sex,
      'height': height,
      'role': role,
    };
  }
}
