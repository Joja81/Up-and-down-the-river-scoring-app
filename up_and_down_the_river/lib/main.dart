import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:upanddowntheriver/player.dart';
import 'package:upanddowntheriver/startScreen.dart';

void main() {
  List<Player> currentPlayers = setPlayer();
  ThemeData initTheme = ThemeData.light();
  runApp(Phoenix(
    //Phoenix allows the application to be restarted at the end of the game'
    child: ThemeProvider(
      initTheme: initTheme,
      child: Builder(builder: (context) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeProvider.of(context),
          home: StartScreen(currentPlayers),
        );
      }),
    ),
  ));
}

List<Player> setPlayer() {
  List<Player> players = new List<Player>();
  return players;
}
