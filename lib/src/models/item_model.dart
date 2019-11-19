import 'dart:convert';

class ItemModel {
  List<_Workout> _workouts = [];

  ItemModel.fromJson(Map<String, dynamic> parsedJson) {
    List<_Workout> temp = [];
    for (int i = 0; i < parsedJson['_id'].length; i++) {
      _Workout result = _Workout(parsedJson['name'][i],parsedJson['description'][i],parsedJson['image'][i]);
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

  _Workout(String name, String description, String image) {
    _name = name;
    _description = description;
    _image = image;
  }

  String get name => _name;

  String get date => _description;

  String get image => _image;
}