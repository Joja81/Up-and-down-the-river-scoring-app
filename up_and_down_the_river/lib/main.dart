import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:upanddowntheriver/player.dart';

import 'CreatePlayerScreen.dart';

void main() {
  runApp(MaterialApp(
    title: 'Up and down the river',
    home: SelectPlayer(),
  ));
}

class SelectPlayer extends StatefulWidget {
  @override
  SelectPlayerState createState() {
    return SelectPlayerState();
  }
}

class SelectPlayerState extends State<SelectPlayer> {
  //Store player info
  List<Player> currentPlayers = new List<Player>();

  List<Widget> playerWidgets = new List<Widget>();

  int i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 100.0,
            ),
            child: FlatButton(
              child: Container(
                padding: EdgeInsets.all(20.0),
                color: Colors.tealAccent,
                child: Center(
                  child: Text('Start'),
                ),
              ),
              onPressed: startGame,
            ),
          ),
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                itemCount: playerWidgets.length,
                itemBuilder: (context, index) {
//                  return playerWidgets[index];
                  return playerWidgets[index];
                },
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.grey,
            ),
            child: FlatButton(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(),
              child: Center(
                child: Text("New player"),
              ),
              onPressed: getNewPlayer,
            ),
          ),
        ]),
      ),
    );
  }

  getNewPlayer() async {
    final Player newPlayer = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreatePlayer()));
    displayPlayer(newPlayer); //Places player on screen
    currentPlayers.insert(0, newPlayer); //Saves player to array
  }

  void displayPlayer(Player player) {
    setState(() {
      playerWidgets.insert(
          0,
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 5.0,
            ),
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: player.userColor,
            ),
            child: Center(
              child: Text(
                player.name,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ));
    });
  }

  void startGame() {
    if()
  }
}
