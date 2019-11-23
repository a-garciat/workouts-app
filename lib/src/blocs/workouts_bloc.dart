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
  Exercise _exercisesFetcher;
  bool _dataReady = false;

  Exercise get allExercises => _exercisesFetcher;

  dataReady() {
    _dataReady=true;
  }

  dataNotReady() {
    _dataReady=false;
  }

  bool checkReady() {
    return _dataReady;
  }

  fetchExercise(name) async{
    ExerciseModel exerciseM = await _repository.fetchExercise(name);
    print ('FETCHED FROM REPOSITORY = ' + exerciseM.getExercise.name.toString());
    _exercisesFetcher=exerciseM.getExercise;
    dataReady();
  }

}