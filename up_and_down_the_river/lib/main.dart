import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:upanddowntheriver/startScreen.dart';

void main() {
  runApp(Phoenix(
    //Phoenix allows the application to be restarted at the end of the game
    child: MaterialApp(
      theme: ThemeData(primarySwatch: Colors.teal),
      title: 'Up and down the river',
      home: SelectPlayer(),
    ),
  ));
}
