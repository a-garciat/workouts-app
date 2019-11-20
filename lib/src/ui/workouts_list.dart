import 'dart:io';

import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../blocs/workouts_bloc.dart';

class WorkoutsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bloc.fetchAllWorkouts();
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de rutinas'),
      ),
      body: StreamBuilder(
        stream: bloc.allWorkouts,
        builder: (context, AsyncSnapshot<ItemModel> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildList(AsyncSnapshot<ItemModel> snapshot) {
    return GridView.builder(
        itemCount: snapshot.data.workouts.length,
        gridDelegate:
        new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          File file = new File("error.png");
          return Image.file(file);

        });
  }
}