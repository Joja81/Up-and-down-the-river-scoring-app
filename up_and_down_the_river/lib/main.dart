import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:upanddowntheriver/startScreen.dart';

void main() {
  runApp(Phoenix(
    child: MaterialApp(
      title: 'Up and down the river',
      home: SelectPlayer(),
    ),
  ));
}
