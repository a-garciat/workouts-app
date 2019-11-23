import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../blocs/workouts_bloc.dart';

class WorkoutsList extends StatelessWidget {

  WorkoutsList({ @required this.workoutSelectedCallback, this.rows });
  final ValueChanged<Workout> workoutSelectedCallback;
  final int rows;

  @override
  Widget build(BuildContext context) {
    blocWorkouts.fetchAllWorkouts();
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de rutinas'),
      ),
      body: StreamBuilder(
        stream: blocWorkouts.allWorkouts,
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
        new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: rows),

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
                onTap: () => workoutSelectedCallback(snapshot.data.workouts[index])
              ),
              child: InkResponse(
                enableFeedback: true,
                child: image,
                onTap: () => workoutSelectedCallback(snapshot.data.workouts[index])
                //onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutPage(snapshot.data.workouts[index])))
              ),
            );
        });
  }
}

  class WorkoutPage extends StatelessWidget {
    /*Workout _workout;
    WorkoutPage( Workout workout){
      _workout = workout;
    }*/
    WorkoutPage({@required this.workout});
    final Workout workout;

  @override
    Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    if (workout == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No item selected!',
            style: textTheme.headline,
          ),
          Text(
            'Please select one on the left.',
            style: textTheme.subhead,
          ),
        ],
      );
    }
    Widget image;
    if(workout.image == ''){
      image = Image.asset('assets/error.png');
    } else {
      image = Image.memory(base64.decode(workout.image));
    }
    ExercisesBloc blocExercises = ExercisesBloc();
    blocExercises.fetchExercise(workout.exercises[0][0]);
    while (!blocExercises.checkReady()) {
      print('Not ready yet');
    }
    Exercise exercise = blocExercises.allExercises;
    print('EXERCISE FETCHED TO VIEW = ' + exercise.toString());

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
                        Row(children: <Widget>[
                          Text(
                          workout.name,
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                          IconButton(color :Colors.green,
                            iconSize: 80,
                            alignment: Alignment.centerRight,
                            icon: Icon(Icons.play_circle_filled),
                            onPressed: () =>Navigator.push(context, MaterialPageRoute(builder: (context) => ExercisePage(workout: workout,exercise: exercise)))
                          ),
                        ],),
                        Container(margin: EdgeInsets.only(top: 15.0, bottom: 8.0)),
                        Text(workout.description),
                        Container(margin: EdgeInsets.only(top: 15.0, bottom: 8.0)),
                        Text("Ejercicios",style: Theme
                            .of(context)
                            .textTheme
                            .headline,),
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount : workout.exercises.length
                            ,itemBuilder:(context, ind){
                          return  Text(
                            workout.exercises[ind][0],
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
}

class MasterDetailContainer extends StatefulWidget {
  @override
  _MasterDetailContainerState createState() =>
      _MasterDetailContainerState();
}

class _MasterDetailContainerState extends State<MasterDetailContainer> {
  // Track the currently selected item here. Only used for
  // tablet layouts.
  Workout _selectedItem;

  Widget _buildMobileLayout() {
    return WorkoutsList(rows: 2,

      // Since we're on mobile, just push a new route for the
      // item details.
      workoutSelectedCallback: (item) {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return WorkoutPage(workout: item);}));
      },
    );
  }

  Widget _buildTabletLayout() {
    // For tablets, return a layout that has item listing on the left
    // and item details on the right.
    return Row(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: WorkoutsList(rows: 1,
            // Instead of pushing a new route here, we update
            // the currently selected item, which is a part of
            // our state now.
            workoutSelectedCallback: (item) {
              setState(() {
                _selectedItem = item;
              });
            },
          ),
        ),
        Flexible(
          flex: 3,
          child: WorkoutPage(
            // The item details just blindly accepts whichever
            // item we throw in its way, just like before.
            workout: _selectedItem,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var useMobileLayout = shortestSide < 600;
    if (useMobileLayout) return _buildMobileLayout();
    else return _buildTabletLayout();
  }
}

class ExercisePage extends StatelessWidget {
  ExercisePage({ @required this.workout, this.exercise});
  final Workout workout;
  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    if (workout == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No item selected!',
            style: textTheme.headline,
          ),
          Text(
            'Please select one on the left.',
            style: textTheme.subhead,
          ),
        ],
      );
    }
    Widget image;
    if(workout.image == ''){
      image = Image.asset('assets/error.png');
    } else {
      image = Image.memory(base64.decode(exercise.image));
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
                        Row(children: <Widget>[
                          Text(
                            exercise.name,
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],),
                        Container(margin: EdgeInsets.only(top: 15.0, bottom: 8.0)),
                        Text(exercise.description),
                        Container(margin: EdgeInsets.only(top: 15.0, bottom: 8.0)),
                        Text("Ejercicios",style: Theme
                            .of(context)
                            .textTheme
                            .headline,),
                      ]
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

