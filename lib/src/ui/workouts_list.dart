import 'dart:convert';
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
          Widget image;
          String name = snapshot.data.workouts[index].name;
          String imageData = snapshot.data.workouts[index].image;
          if (imageData == '') {
             image = Image.asset('assets/error.png');
          }else{
             image = Image.memory(base64.decode(imageData));
          }
            return GridTile(
              header: InkResponse(
                enableFeedback: true,
                child: Text(name,
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline,
                ),
                //leading: Image.asset('assets/error.png'),
                onTap: () => print(index),
              ),
              child: InkResponse(
                enableFeedback: true,
                child: image,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutPage(snapshot.data.workouts[index])))
              ),
            );
        });
  }
}

  class WorkoutPage extends StatelessWidget {
    Workout _workout;
  WorkoutPage( Workout workout){
     _workout = workout;
  }

  @override
    Widget build(BuildContext context) {
    Widget image;
    if(_workout.image == ''){
      image = Image.asset('assets/error.png');
    }else{
      image = Image.memory(base64.decode(_workout.image));
    }
      return Scaffold(
        body: SafeArea(
          top: false,
          bottom: false,
          child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: 200.0,
                    floating: false,
                    pinned: true,
                    elevation: 0.0,
                    flexibleSpace: FlexibleSpaceBar(
                        background:  image)
                  ),
                ];
              },
              body: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(margin: EdgeInsets.only(top: 5.0)),
                        Text(
                          _workout.name,
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(margin: EdgeInsets.only(top: 15.0, bottom: 8.0)),
                        Text(_workout.description),
                        Container(margin: EdgeInsets.only(top: 15.0, bottom: 8.0)),
                        Text("Ejercicios",style: Theme
                            .of(context)
                            .textTheme
                            .headline,),
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount : _workout.exercises.length
                            ,itemBuilder:(context, ind){
                          return  Text(
                            _workout.exercises[ind][0],
                          );
                        })
                      ]
                    ),
                  ),
                  ],
              )),
        ),
      );
    }

    Widget _buildItem(List<String> exercise) {
      return new ListTile(
        title: new Text(exercise[0]),
        subtitle: new Text(exercise[1]),
      );
    }

}
