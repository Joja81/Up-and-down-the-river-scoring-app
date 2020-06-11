import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upanddowntheriver/player.dart';
import 'package:upanddowntheriver/startScreen.dart';

void main() {
  List<Player> currentPlayers =
      setPlayer(); //Creates blank currentPlayers list to send to startScreen
  ThemeData initTheme = ThemeData.light();
  /*
 Copyright (c) 2020 Kherel

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
   */
  runApp(ThemeProvider(
    //Allows switching of themes in the application
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
