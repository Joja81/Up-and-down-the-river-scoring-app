import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:upanddowntheriver/guessCollection.dart';
import 'package:upanddowntheriver/player.dart';

import 'CreatePlayerScreen.dart';

class SelectPlayer extends StatefulWidget {
  @override
  SelectPlayerState createState() {
    return SelectPlayerState();
  }
}

class SelectPlayerState extends State<SelectPlayer> {
  //Store player info
  List<Player> currentPlayers = new List<Player>();
  int maxNumberCards = 5;

  int i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20.0),
            ),
            margin: EdgeInsets.symmetric(
              vertical: 30.0,
              horizontal: 100.0,
            ),
            child: FlatButton(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Start',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    Icon(
                      Icons.flight_takeoff,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              onPressed: moveNextScreen,
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Text('Max number of cards'),
                NumberPicker.horizontal(
                  initialValue: maxNumberCards,
                  minValue: 2,
                  maxValue: 52,
                  onChanged: (value) => setState(() => maxNumberCards = value),
                ),
              ],
            ),
          ),
          Expanded(
            child: checkPlayerNumber(currentPlayers),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        icon: Icon(Icons.person_add),
        label: Text("Add player"),
        onPressed: getNewPlayer,
      ),
    );
  }

  getNewPlayer() async {
    final Player newPlayer = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreatePlayer()));
    if (newPlayer.userColor != null) {
      currentPlayers.add(newPlayer); //Saves player to array
    }
    print(currentPlayers.length);
  }

  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void removePlayer(int index) {
    setState(() {
      currentPlayers.removeAt(index);
    });
  }

  checkPlayerNumber(List<Player> currentPlayers) {
    if (currentPlayers.length > 0) {
      return displayList();
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Please add a player or two'),
          ],
        ),
      );
    }
  }

  void moveNextScreen() {
    if (currentPlayers.length > 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              GuessCollection(currentPlayers, 1, maxNumberCards, 1),
        ),
      );
    } else {
      Alert(
        context: context,
        type: AlertType.info,
        title: "Sorry",
        desc: "You do not have enough players",
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }
  }

  displayList() {
    return ListView.builder(
      itemCount: currentPlayers.length,
      itemBuilder: (context, index) {
        String heroName = 'hero' + currentPlayers[index].name;

        return Hero(
          tag: heroName,
          child: Material(
            type: MaterialType.transparency,
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: currentPlayers[index].userColor,
                ),
                title: Text(currentPlayers[index].name),
              ),
              actions: <Widget>[
                IconSlideAction(
                  caption: 'Remove',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    removePlayer(index);
                    _showSnackBar(context, 'Removed');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
