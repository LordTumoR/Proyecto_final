class ExerciseEntity {
  final int? id;
  final String? name;
  final String? description;
  final String? image;
  final DateTime? dateTime;
  final int? repetitions;
  final double? weight;
  final String? muscleGroup;
  final int? sets;

  ExerciseEntity(
      {this.id,
      this.name,
      this.description,
      this.image,
      this.dateTime,
      this.repetitions,
      this.weight,
      this.muscleGroup,
      this.sets});
}
