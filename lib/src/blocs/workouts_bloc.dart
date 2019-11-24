import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';

class WorkoutsBloc {
  final _repository = Repository();
  final _workoutsFetcher = PublishSubject<ItemModel>();

  Observable<ItemModel> get allWorkouts => _workoutsFetcher.stream;

  fetchAllWorkouts() async {
    ItemModel itemModel = await _repository.fetchAllWorkouts();
    _workoutsFetcher.sink.add(itemModel);
  }

  dispose() {
    _workoutsFetcher.close();
  }
}

final blocWorkouts = WorkoutsBloc();
final blocExercise = ExercisesBloc();

class ExercisesBloc {
  final _repository = Repository();
  final _exercisesFetcher = PublishSubject<ExerciseModel>();


  Observable<ExerciseModel> get allExercises => _exercisesFetcher.stream;

  fetchExercise(String nombre) async {
    ExerciseModel itemModel = await _repository.fetchExercise(nombre);
    _exercisesFetcher.sink.add(itemModel);
  }

  dispose() {
    _exercisesFetcher.close();
  }

}

