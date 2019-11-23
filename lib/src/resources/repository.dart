import 'dart:async';
import 'workout_api_provider.dart';
import '../models/item_model.dart';

class Repository {
  final workoutsApiProvider = WorkoutApiProvider();
  final exerciseApiProvider = ExerciseApiProvider();
  Future<ItemModel> fetchAllWorkouts() => workoutsApiProvider.fetchWorkoutList();
  Future<ExerciseModel> fetchExercise(nombre)  =>  exerciseApiProvider.fetchExercise(nombre);
}