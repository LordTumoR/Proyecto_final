import 'package:flutter_tracktrail_app/data/datasources/progress_datasource.dart';
import 'package:flutter_tracktrail_app/domain/repositories/progress_repository.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressRemoteDataSource remoteDataSource;

  ProgressRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<dynamic>> getEvolutionWeight(String muscleGroup) async {
    try {
      return await remoteDataSource.getEvolutionWeight(muscleGroup);
    } catch (e) {
      throw Exception('Error al obtener evolución de peso: $e');
    }
  }

  @override
  Future<List<dynamic>> getEvolutionRepsSets(String muscleGroup) async {
    try {
      return await remoteDataSource.getEvolutionRepsSets(muscleGroup);
    } catch (e) {
      throw Exception('Error al obtener evolución de repeticiones y sets: $e');
    }
  }

  @override
  Future<List<dynamic>> getPersonalRecords() async {
    try {
      return await remoteDataSource.getPersonalRecords();
    } catch (e) {
      throw Exception('Error al obtener récords personales: $e');
    }
  }

  @override
  Future<int> getTrainingStreak() async {
    try {
      return await remoteDataSource.getTrainingStreak();
    } catch (e) {
      throw Exception('Error al obtener la racha de entrenamiento: $e');
    }
  }
}
