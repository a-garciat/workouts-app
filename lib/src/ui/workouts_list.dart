import 'dart:convert';
import 'package:flutube/flutube.dart';
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../blocs/workouts_bloc.dart';

class WorkoutsList extends StatelessWidget {
  WorkoutsList({@required this.workoutSelectedCallback, this.rows});

  final ValueChanged<Workout> workoutSelectedCallback;
  final int rows;

  @override
  Widget build(BuildContext context) {
    blocWorkouts.fetchAllWorkouts();
    return Scaffold(
      backgroundColor: Colors.white,
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
        padding: const EdgeInsets.all(4),
        itemCount: snapshot.data.workouts.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: rows),
        itemBuilder: (BuildContext context, int index) {
          Widget image;
          String name = snapshot.data.workouts[index].name;
          String imageData = snapshot.data.workouts[index].image;
          if (imageData == '') {
            image = Image.asset('assets/error.png', height: 35);
          } else {
            image = Image.memory(base64.decode(imageData), height: 35);
          }
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  child: Flex(direction: Axis.vertical, children: <Widget>[
                Expanded(
                    flex: 5,
                    child: Material(
                        elevation: 8.0,
                        color: Colors.lightGreenAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(new Radius.circular(16.0)),
                        ),
                        child: GridTile(
                          header: InkResponse(
                              enableFeedback: true,
                              child: Text(
                                name,
                                style: Theme.of(context).textTheme.headline,
                              ),
                              //leading: Image.asset('assets/error.png'),
                              onTap: () => workoutSelectedCallback(
                                  snapshot.data.workouts[index])),
                          child: InkResponse(
                            enableFeedback: true,
                            child: image,
                            onTap: () => workoutSelectedCallback(
                                snapshot.data.workouts[index]),
                            // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutPage(snapshot.data.workouts[index])))
                          ),
                        )))
              ])));
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
            'No se ha seleccionado una rutina',
            style: textTheme.headline,
          ),
          Text(
            'Selecciona una a la izquierda',
            style: textTheme.subhead,
          ),
        ],
      );
    }
    Widget image;
    if (workout.image == '') {
      image = Image.asset('assets/error.png');
    } else {
      image = Image.memory(base64.decode(workout.image));
    }
    return Scaffold(
      backgroundColor: Colors.white,
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
                    flexibleSpace: FlexibleSpaceBar(background: image)),
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
                        Row(
                          children: <Widget>[
                            Text(
                              workout.name,
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                                color: Colors.green,
                                iconSize: 80,
                                alignment: Alignment.centerRight,
                                icon: Icon(Icons.play_circle_filled),
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ExercisePage(workout, 0)))),
                          ],
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 15.0, bottom: 8.0)),
                        Text(workout.description),
                        Container(
                            margin: EdgeInsets.only(top: 15.0, bottom: 8.0)),
                        Text(
                          "Ejercicios",
                          style: Theme.of(context).textTheme.headline,
                        ),
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: workout.exercises.length,
                            itemBuilder: (context, ind) {
                              return Text(
                                workout.exercises[ind][0],
                              );
                            })
                      ]),
                ),
              ],
            )),
      ),
    );
  }
}

class MasterDetailContainer extends StatefulWidget {
  @override
  _MasterDetailContainerState createState() => _MasterDetailContainerState();
}

class _MasterDetailContainerState extends State<MasterDetailContainer> {
  // Track the currently selected item here. Only used for
  // tablet layouts.
  Workout _selectedItem;

  Widget _buildMobileLayout() {
    return WorkoutsList(
      rows: 2,

      // Since we're on mobile, just push a new route for the
      // item details.
      workoutSelectedCallback: (item) {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return WorkoutPage(workout: item);
        }));
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
          child: WorkoutsList(
            rows: 1,
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
    if (useMobileLayout)
      return _buildMobileLayout();
    else
      return _buildTabletLayout();
  }
}

class ExercisePage extends StatelessWidget {
  Workout _workout;
  int _exer;
  String _restantes;
  int _restantesParseados;
  bool _tiempo;
  String _mensajeDuracion;

  ExercisePage(Workout workout, int exer) {
    _workout = workout;
    _exer = exer;
  }

  @override
  Widget build(BuildContext context) {
    blocExercise.fetchExercise(_workout.exercises[_exer][0]);
    _restantes = _workout.exercises[_exer][1];
    if (_restantes.contains('rep')) {
      _tiempo = false;
    } else {
      _tiempo = true;
    }
    _restantesParseados =
        int.parse(_restantes.replaceAll(new RegExp('[^0-9.]'), ''));
    if (_tiempo == true) {
      _mensajeDuracion =
          'Repetir durante ' + _restantesParseados.toString() + ' segundos';
    } else {
      _mensajeDuracion =
          'Realizar ' + _restantesParseados.toString() + ' repeticiones';
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: blocExercise.allExercises,
        builder: (context, AsyncSnapshot<ExerciseModel> snapshot) {
          if (snapshot.hasData) {
            return buildView(snapshot, context);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildView(AsyncSnapshot<ExerciseModel> snapshot, context) {
    Widget image;
    if (snapshot.data.exercise.image == '') {
      image = Image.asset('assets/error.png');
    } else {
      image = Image.memory(base64.decode(snapshot.data.exercise.image));
    }
    Widget button;
    if (_exer < _workout.exercises.length - 1) {
      button = IconButton(
          color: Colors.green,
          iconSize: 80,
          alignment: Alignment.centerRight,
          icon: Icon(Icons.navigate_next),
          onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ExercisePage(_workout, _exer + 1))));
    } else {
      button = IconButton(
        color: Colors.green,
        iconSize: 80,
        alignment: Alignment.centerRight,
        icon: Icon(Icons.grid_on),
        onPressed: () => Navigator.pop(context),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
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
                    flexibleSpace: FlexibleSpaceBar(background: image)),
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
                        Row(
                          children: <Widget>[
                            Text(
                              snapshot.data.exercise.name,
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            button,
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              _mensajeDuracion,
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 15.0, bottom: 8.0)),
                        Text(snapshot.data.exercise.description),
                        Container(
                            margin: EdgeInsets.only(top: 15.0, bottom: 8.0)),
                        FluTube(
                          snapshot.data.exercise.video,
                          aspectRatio: 16 / 9,
                          autoPlay: true,
                          looping: true,
                          onVideoStart: () {},
                          onVideoEnd: () {},
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 15.0, bottom: 8.0)),
                        /*Text("Ejercicios",style: Theme
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
                        })*/
                      ]),
                ),
              ],
            )),
      ),
    );
  }
}
