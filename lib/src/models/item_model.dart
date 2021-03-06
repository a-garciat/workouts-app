import 'dart:convert';

class ItemModel {
  List<Workout> _workouts = [];
  ItemModel.fromJson(List<Map<String, dynamic>> parsedJson) {
    List<Workout> temp = [];
    for (int i = 0; i < parsedJson.length; i++) {
      String joinedDescription = '';
      for (int j = 0; j<parsedJson[i]['description'].length; j++) {
        joinedDescription = joinedDescription + parsedJson[i]['description'][j];
      }
      String image = '';
      if (parsedJson[i]['image'] != '') {
        image = utf8.decode(parsedJson[i]['image'].byteList);
      }
      Workout result = Workout(parsedJson[i]['name'],joinedDescription,image,parsedJson[i]['exercises']);
      temp.add(result);
    }
    _workouts = temp;
  }
  List<Workout> get workouts => _workouts;
}

class Workout {
  String _name;
  String _description;
  String _image;
  List<dynamic> _exercises;

  Workout(String name, String description, String image, List<dynamic> exercises) {
    _name = name;
    _description = description;
    _image = image;
    _exercises = exercises;

  }

  String get name => _name;

  String get description => _description;

  String get image => _image;

  List<dynamic> get exercises => _exercises;

}
class Exercise{
  String _name;
  String _description;
  String _image;
  String _video;
  Exercise(String name, String description, String image, String video) {
    _name = name;
    _description = description;
    _image = image;
    _video = video;
  }

  String get name => _name;

  String get description => _description;

  String get image => _image;

  String get video => _video;
}

class ExerciseModel{
  Exercise exercise;
  ExerciseModel.fromJson(Map<String,dynamic> exercises){
    String description = "";
    int desmax;
    try{
      desmax = exercises['description'].length;
    }catch (e){
      desmax=0;
      description = 'No hay descripcion';
    }
    String image = '';
    try{
      image = utf8.decode(exercises['image'].byteList);
    }catch (e){
      image = '';
    }
    for(int i = 0; i< desmax;i++) {
      description = description + exercises['description'][i];
    }
    String name;
    try{
      name = exercises['name'];
    }catch (e){
      name = 'No tiene nombre ';
    }
    String video;
    try{
      video = exercises['video'];
    }catch (e){
      video = '';
    }
    exercise = Exercise(name, description, image, video);
  }
}
