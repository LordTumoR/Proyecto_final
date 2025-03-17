import 'package:flutter_tracktrail_app/data/datasources/progress_datasource.dart';

abstract class ProgressRepository {
  Future<List<dynamic>> getEvolutionWeight(String muscleGroup);
  Future<List<dynamic>> getEvolutionRepsSets(String muscleGroup);
  Future<List<dynamic>> getPersonalRecords();
  Future<int> getTrainingStreak();
}
