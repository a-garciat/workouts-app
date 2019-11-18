import 'dart:async';
import 'dart:convert';
import '../models/item_model.dart';

class WorkoutApiProvider {

  Future<ItemModel> fetchWorkoutList() async {
    final response = /*aqui hay que coger la respuesta de la BBDD*/;
    return ItemModel.fromJson(json.decode(response));
  }
}