import 'dart:async';
import 'workout_api_provider.dart';
import '../models/item_model.dart';

class Repository {
  final moviesApiProvider = WorkoutApiProvider();

  Future<ItemModel> fetchAllWorkouts() => moviesApiProvider.fetchWorkoutList();
}