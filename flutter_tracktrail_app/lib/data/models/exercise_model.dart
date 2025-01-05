class ExerciseModel {
  final int idExercise;
  final String name;
  final String description;
  final String image;

  ExerciseModel({
    required this.idExercise,
    required this.name,
    required this.description,
    required this.image,
  });

  @override
  String toString() {
    return 'Exercise{idExercise: $idExercise, name: $name, description: $description, image: $image}';
  }

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      idExercise: json['id_exercises'] ?? 0,
      name: json['name'] ?? 'Unknown',
      description: json['description'] ?? 'No description',
      image: json['images'] ?? 'no_image.jpg',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_exercises': idExercise,
      'name': name,
      'description': description,
      'images': image,
    };
  }
}
