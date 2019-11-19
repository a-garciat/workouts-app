import 'dart:async';
import 'dart:convert';
import '../models/item_model.dart';
import 'package:mongo_dart/mongo_dart.dart';

class WorkoutApiProvider {

  Future<ItemModel> fetchWorkoutList() async {
    Db db = new Db("mongodb://10.0.2.2:27017/workouts");
    await db.open();
    var workouts = db.collection('workouts');
    final response = await workouts.find().toList();
    await db.close();
    return ItemModel.fromJson(jsonDecode(response.toString()));
  }
}