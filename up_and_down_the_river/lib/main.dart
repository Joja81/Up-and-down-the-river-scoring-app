import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upanddowntheriver/player.dart';
import 'package:upanddowntheriver/startScreen.dart';

void main() {
  List<Player> currentPlayers =
      setPlayer(); //Creates blank currentPlayers list to send to startScreen
  ThemeData initTheme = ThemeData.light();
  runApp(ThemeProvider(
    //Allows switching of themes in the application.
    //Also allows the reativity of text to different text sizes defined within android, allows text to enlarge to match system settings, good for people with poor sight as text expands to accomodate.
    initTheme: initTheme, //Theme which is shown when the application is loaded
    child: Builder(builder: (context) {
      return MaterialApp(
        title: 'Down the River',
        theme: ThemeProvider.of(context),
        home: StartScreen(currentPlayers),
      );
    }),
  ));
}

List<Player> setPlayer() {
  List<Player> players = new List<Player>();
  return players;
}
