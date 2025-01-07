class RoutineEntity {
  final int id;
  final String name;
  final String goal;
  final int duration;
  final bool isPrivate;
  final String difficulty;
  final String progress;
  final int? idUser;

  RoutineEntity({
    required this.id,
    required this.name,
    required this.goal,
    required this.duration,
    required this.isPrivate,
    required this.difficulty,
    required this.progress,
    this.idUser,
  });
  @override
  String toString() {
    return 'RoutineEntity(name: $name, goal: $goal, duration: $duration, isPrivate: $isPrivate)';
  }
}
