import 'package:flutter_tracktrail_app/data/datasources/progress_datasource.dart';

abstract class ProgressRepository {
  Future<List<dynamic>> getEvolutionWeight(int exerciseId);
  Future<List<dynamic>> getEvolutionRepsSets(int exerciseId);
  Future<List<dynamic>> getPersonalRecords();
  Future<int> getTrainingStreak(int userId);
}
