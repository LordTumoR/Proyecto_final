class UserDatabaseEntity {
  final int id;
  final String name;
  final String surname;
  final String email;
  final String password;
  final double weight;
  final DateTime dateOfBirth;
  final String sex;
  final double height;
  final double role;
  final String? avatar;

  UserDatabaseEntity({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.password,
    required this.weight,
    required this.dateOfBirth,
    required this.sex,
    required this.height,
    required this.role,
    this.avatar,
  });

  @override
  String toString() {
    return 'UserDatabaseEntity{id: $id, name: $name, surname: $surname, email: $email, weight: $weight, dateOfBirth: $dateOfBirth, sex: $sex, height: $height, role: $role}';
  }
}
