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
    return Scaffold(
      appBar: AppBar(
        leading: ThemeSwitcher(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.brightness_3),
              onPressed: () => changeTheme(context),
            );
          },
        ),
        title: Text("Down the river"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: displayHelp,
          )
        ],
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
            child: Column(
              children: <Widget>[
                Text('Max number of cards'),
                /* Copyright 2017 Marcin Szalek

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */

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
      bool newName = checkForSameName(newPlayer);
      if (newName == true) {
        setState(() {
          currentPlayers.add(newPlayer); //Saves player to array
        });
      } else {
        Alert(
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
      /*
      MIT License

Copyright (c) 2018 Ratel (https://ratel.com.tr)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
       */
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
            /* MIT License

Copyright (c) 2018 Romain Rastel

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE. */
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
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Move to top',
                  color: Theme.of(context).buttonColor,
                  icon: Icons.vertical_align_top,
                  onTap: () {
                    movePlayer(index, false);
                  },
                ),
                IconSlideAction(
                  caption: 'Move to bottom',
                  color: Theme.of(context).primaryColor,
                  icon: Icons.vertical_align_bottom,
                  onTap: () {
                    movePlayer(index, true);
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
      Player tempPlayer = currentPlayers[index];
      currentPlayers.removeAt(index);
      if (bottom == true) {
        currentPlayers.add(tempPlayer);
      } else {
        currentPlayers.insert(0, tempPlayer);
      }
    });
  }

  void displayHelp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Help'),
          content: Text(
              'This app is a basic scorer for the game "Up and Down the River". Swiping left or right on a name allows you to delete or rearrange it when setting up the game. \n\n V1.01 \n\n By Joshua Smee'),
        );
      },
    );
  }

  bool checkForSameName(Player newPlayer) {
    bool returnValue = true;
    for (int i = 0; i < currentPlayers.length; i++) {
      if (currentPlayers[i].name.toUpperCase() ==
          newPlayer.name.toUpperCase()) {
        returnValue = false;
      }
    }
    return returnValue;
  }

  void changeTheme(BuildContext context) {
    ThemeData darkTheme = ThemeData.dark();
    ThemeData lightTheme = ThemeData.light();
    if (Theme.of(context).brightness == Brightness.dark) {
      ThemeSwitcher.of(context).changeTheme(theme: lightTheme);
    } else {
      ThemeSwitcher.of(context).changeTheme(theme: darkTheme);
    }
  }
}
