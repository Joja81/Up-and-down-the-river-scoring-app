import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:upanddowntheriver/guessCollection.dart';
import 'package:upanddowntheriver/player.dart';

import 'CreatePlayerScreen.dart';

class StartScreen extends StatefulWidget {
  @override
  StartScreenState createState() {
    return StartScreenState();
  }
}

class StartScreenState extends State<StartScreen> {
  //Store player info
  List<Player> currentPlayers = new List<Player>();
  int maxNumberCards = 5; //Sets the initial value

  int i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Down the river"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Theme.of(context).primaryColor,
            ),
            margin: EdgeInsets.symmetric(
              vertical: 30.0,
              horizontal: 100.0,
            ),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Theme.of(context).accentColor,
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
                  minValue: 1,
                  maxValue: 52,
                  onChanged: (value) => setState(() =>
                      maxNumberCards = value), //Changes the maxNumberCard value
                ),
              ],
            ),
          ),
          Expanded(
            child: displayPlayers(currentPlayers),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(
          Icons.person_add,
          color: Colors.white,
        ),
        label: Text(
          "Add player",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: getNewPlayer,
      ),
    );
  }

  getNewPlayer() async {
    //Allows it to wait for reply
    final Player newPlayer = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CreatePlayer())); //Shifts screen to create player screen
    if (newPlayer.color != null) {
      //Color is null if player hits back button instead of create player
      currentPlayers.add(newPlayer); //Saves player to array
    }
  }

  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void removePlayer(int index) {
    setState(() {
      //Updates anything related to the variables enclosed
      currentPlayers.removeAt(index);
    });
  }

  displayPlayers(List<Player> currentPlayers) {
    if (currentPlayers.length > 0) {
      //Displays players if there are any otherwise it displays message saying to add players
      return displayList();
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Please add two or more players'),
          ],
        ),
      );
    }
  }

  void moveNextScreen() {
    if (currentPlayers.length > 1) {
      Navigator.pushReplacement(
        //Change to next screen, deleting current screen
        // Changes screen to score guess collection
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
        String heroName =
            'hero' + currentPlayers[index].name; //Name for animation store

        return Hero(
          tag: heroName, //Identifier for animation
          child: Material(
            type: MaterialType.transparency,
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: currentPlayers[index].color,
                ),
                title: Text(currentPlayers[index].name),
              ),
              actions: <Widget>[
                IconSlideAction(
                  //Allows you to slide from the left to delete player
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
