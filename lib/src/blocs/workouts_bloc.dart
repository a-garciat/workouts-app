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

class ExercisesBloc {
  final _repository = Repository();
  ExerciseModel _exerciseM;
  Exercise _exercise = null;
  Exercise get exercise => _exercise;
  fetchExercise(name) async{
    _exerciseM = await _repository.fetchExercise(name);
    _exercise = _exerciseM.exercise;
  }

}