import 'dart:convert';

class ItemModel {
  List<_Workout> _workouts = [];

  ItemModel.fromJson(Map<String, dynamic> parsedJson) {
    print(parsedJson['workouts'].length);
    List<_Workout> temp = [];
    for (int i = 0; i < parsedJson['_id'].length; i++) {
      _Workout result = _Workout(parsedJson['_id'][i]);
      temp.add(result);
    }
    _workouts = temp;
  }

  List<_Workout> get workouts => _workouts;

}

class _Workout {
  String _name;
  String _description;
  String _image;

  _Workout(result) {
    _name = result['name'];
    _description = result['description'];
    _image = result['image'];
  }

  String get name => _name;

  String get date => _description;

  String get image => _image;
}