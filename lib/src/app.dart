import 'package:flutter/material.dart';
import 'ui/workouts_list.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.lightGreen[800],
        accentColor: Colors.lightGreenAccent[600],


        // Define the default font family.
        fontFamily: 'Montserrat',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.black),
          title: TextStyle(fontSize: 30.0, fontStyle: FontStyle.italic, color: Colors.black),
          body1: TextStyle(fontSize: 20.0, fontFamily: 'Hind', color: Colors.black),
        ),
      ),
      home: Scaffold(
        body: MasterDetailContainer(),
      ),
    );
  }
}