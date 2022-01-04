import 'dart:ui';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:upanddowntheriver/guessCollection.dart';
import 'package:upanddowntheriver/player.dart';

import 'createPlayerScreen.dart';

class StartScreen extends StatefulWidget {
  final List<Player> currentPlayers;
  StartScreen(this.currentPlayers);
  @override
  StartScreenState createState() {
    return StartScreenState(currentPlayers);
  }
}

class StartScreenState extends State<StartScreen> {
  //Store player info
  List<Player> currentPlayers;
  StartScreenState(this.currentPlayers);
  int maxNumberCards = 5; //Sets the initial value

  int i = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //Stops back button closing application
      onWillPop: () {
        return new Future(() => false);
      },
      child: ThemeSwitchingArea(
        child: Scaffold(
          appBar: AppBar(
            leading: ThemeSwitcher(
              //Allows for theme switching code
              builder: (context) {
                return IconButton(
                  //Button to change application theme
                  icon: Icon(Icons.brightness_3),
                  onPressed: () => changeTheme(context),
                );
              },
            ),
            title: Text("Down the river"),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                //Button for help screen
                icon: Icon(Icons.help_outline),
                onPressed: displayHelp,
              )
            ],
          ),
          body: SafeArea(
            //Stops the application going into non-readable parts of screen
            child: Column(children: <Widget>[
              Container(
                //Sorounds start button
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Theme.of(context).primaryColor,
                ),
                margin: EdgeInsets.symmetric(
                  vertical: 30.0,
                  horizontal: 100.0,
                ),
                child: FlatButton(
                  //Start button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Theme.of(context).primaryColor,
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
                //Allows entry of number of cards
                child: Column(
                  children: <Widget>[
                    Text('Max number of cards'),
                    SizedBox(height: 10,),
                    ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                        // enable touch and mouse gesture
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      }),
                      child: NumberPicker(
                        value: maxNumberCards,
                        axis: Axis.horizontal,
                        minValue: 1,
                        maxValue: 52,
                        onChanged: (value) => setState(() => maxNumberCards =
                            value), //Changes the maxNumberCard value
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: displayPlayers(
                    currentPlayers), //Displays created players or message about creating players
              ),
            ]),
          ),
          floatingActionButton: FloatingActionButton.extended(
            //Floating button for creating player
            icon: Icon(
              Icons.person_add,
            ),
            label: Text(
              "Add player",
            ),
            onPressed: getNewPlayer,
          ),
        ),
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
      bool newName =
          checkForSameName(newPlayer); //Checks if player name is already taken
      if (newName == true) {
        setState(() {
          //Updates screen
          currentPlayers.add(newPlayer); //Saves player to array
        });
      } else {
        Alert(
          //Dispalys message that player name is already taken
          context: context,
          type: AlertType.warning,
          title: "Sorry",
          desc: "More then one player can not have the same name",
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
  }

  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(text))); //Displays message in popup snackbar at bottom\
  }

  void removePlayer(int index) {
    setState(() {
      //Updates the display
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
        //Change to guess collection, deleting current screen to remove back button
        context,
        MaterialPageRoute(
          builder: (context) => GuessCollection(
              currentPlayers,
              1,
              maxNumberCards,
              1), //Sets destination and variables to be send, sends 1 for round and card number to start game
        ),
      );
    } else {
      Alert(
        //Shows popup message to user if there are not enough players
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
            onPressed: () => Navigator.pop(context), //Puts back on start screen
            width: 120,
          )
        ],
      ).show();
    }
  }

  displayList() {
    return ListView.builder(
      //Creates an individual entry in list
      itemCount: currentPlayers.length,
      itemBuilder: (context, index) {
        String heroName =
            'hero' + currentPlayers[index].name; //Name for animation store

        return Hero(
          tag: heroName, //Identifier for animation
          child: Material(
            //Keeps animatios smooth as combines all the widgets in it
            type: MaterialType.transparency,
            child: Slidable(
              //Allows sliding actions
              actionPane:
                  SlidableDrawerActionPane(), //Motion for sliding actions
              actionExtentRatio: 0.25,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: currentPlayers[index]
                      .color, //Creates circle with user colour
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
                    removePlayer(index); //Removes player from array and screen
                    _showSnackBar(context,
                        'Removed'); //Displays message in snack bar to user
                  },
                ),
              ],
              secondaryActions: <Widget>[
                //Sets actions for sliding from the right
                IconSlideAction(
                  caption: 'Move to top',
                  color: Theme.of(context).buttonColor,
                  icon: Icons.vertical_align_top,
                  onTap: () {
                    movePlayer(
                        index, false); //False shows that not moving to bottom
                  },
                ),
                IconSlideAction(
                  caption: 'Move to bottom',
                  color: Theme.of(context).primaryColor,
                  icon: Icons.vertical_align_bottom,
                  onTap: () {
                    movePlayer(index, true); //True shows that moving to top
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void movePlayer(int index, bool bottom) {
    setState(() {
      //Updates the screen
      Player tempPlayer = currentPlayers[index]; //Puts player in temp storage
      currentPlayers.removeAt(index); //Removes player from list
      if (bottom == true) {
        currentPlayers.add(tempPlayer); //Adds player to end
      } else {
        currentPlayers.insert(0, tempPlayer); //Adds player to start
      }
    });
  }

  void displayHelp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //Shows pop up window to user
          title: Text('Help'),
          content: Text(
              'This app is a basic scorer for the game "Up and Down the River". Swiping left or right on a name allows you to delete or rearrange it when setting up the game. \n\n V1.02.1 \n\n By Joshua Smee'),
        );
      },
    );
  }

  bool checkForSameName(Player newPlayer) {
    bool newName = true;
    for (int i = 0; i < currentPlayers.length; i++) {
      //Runs through names and makes sure that name is not all ready used. Causes problem with hero animation if names are identical
      if (currentPlayers[i].name.toUpperCase() ==
          newPlayer.name.toUpperCase()) {
        newName =
            false; //Changes new name to false if it finds that name is same as another
      }
    }
    return newName;
  }

  void changeTheme(BuildContext context) {
    ThemeData darkTheme = ThemeData.dark(); //Creates themes that can be added
    ThemeData lightTheme = ThemeData.light();
    if (Theme.of(context).brightness == Brightness.dark) {
      //Checks to see if dark mode is active or not
      ThemeSwitcher.of(context).changeTheme(
          theme: lightTheme); //Sets theme to light if them is currently dark
    } else {
      ThemeSwitcher.of(context).changeTheme(
          theme: darkTheme); //Sets theme to dark if theme is currently light
    }
  }
}
