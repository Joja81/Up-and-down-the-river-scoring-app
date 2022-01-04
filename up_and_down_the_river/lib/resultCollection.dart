import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:upanddowntheriver/player.dart';
import 'package:upanddowntheriver/scoreDisplay.dart';

class ResultCollection extends StatefulWidget {
  final List<Player> currentPlayers;
  final int cardNumber;
  final List<int> guesses;
  final int maxNumberCards;
  final int roundNumber;
  @override
  ResultCollection(this.currentPlayers, this.cardNumber, this.guesses,
      this.maxNumberCards, this.roundNumber); //Gets values from last page
  ResultCollectionState createState() {
    return ResultCollectionState(currentPlayers, cardNumber, guesses,
        maxNumberCards, roundNumber); //Sends values to state
  }
}

class ResultCollectionState extends State<ResultCollection> {
  final List<Player> currentPlayers;
  final int cardNumber;
  final List<int> guesses;
  final int maxNumberCards;
  final int roundNumber;
  ResultCollectionState(this.currentPlayers, this.cardNumber, this.guesses,
      this.maxNumberCards, this.roundNumber); //Collects states

  List<int> results;
  @override
  void initState() {
    super.initState();
    results = List.generate(currentPlayers.length,
        (i) => 0); //Creates list of results, sets initial value to 0
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        //Catches back button from closing application
        return new Future(() => false);
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          //Button to proceed to next screen
          onPressed: checkResults,
          icon: Icon(Icons.done_all),
          label: Text("View scores"),
        ),
        appBar: AppBar(
          title: Text(
              'Enter results: $cardNumber cards'), //Shows how many cards there are
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Material(
          child: GridView.builder(
            //Grid to display players
            itemCount: currentPlayers.length, //Length of grid
            itemBuilder: (context, index) {
              //Builder for each individual widget in grid
              return displayPlayers(index);
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //Width of grid
            ),
          ),
        ),
      ),
    );
  }

  Widget displayPlayers(int index) {
    //Creates widget for each player
    String heroName =
        'hero' + currentPlayers[index].name; //Identifier for animation

    return Hero(
      tag: heroName,
      child: Material(
        //Unifies animations
        type: MaterialType.transparency,
        child: Container(
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color:
                currentPlayers[index].color, //Sets colour of widget background
          ),
          child: Column(
            children: <Widget>[
              Text(
                //Player name
                currentPlayers[index].name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Guess : ' +
                    guesses[index].toString(), //Shows the guess of the player
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              Theme(
                data: ThemeData(
                  accentColor: Colors.white, //Sets color of number scroller
                ),
                child: Expanded(
                  child: ScrollConfiguration(
                    behavior:
                        ScrollConfiguration.of(context).copyWith(dragDevices: {
                      // enable touch and mouse gesture
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    }),
                    child: NumberPicker(
                      //Selector for result
                      value: results[index],
                      axis: Axis.horizontal,
                      minValue: 0,
                      maxValue:
                          cardNumber, //Stops player making result bigger then possible
                      onChanged: (value) => setState(() => results[index] =
                          value), //Updates value as player moves scroller
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void checkResults() {
    int resultSum = 0;
    for (int i = 0; i < results.length; i++) {
      //Sums results
      resultSum = resultSum + results[i];
    }
    if (resultSum == cardNumber) {
      //Checks to make sure correct number fo results entered
      changeToScore(); //Moves to next screen
    } else {
      displayWarning(); //Displays warning to user that results have been entered wrong
    }
  }

  void changeToScore() {
    //Moves to scores screen and deletes current screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ScoreDisplay(currentPlayers, cardNumber,
            maxNumberCards, results, guesses, roundNumber),
      ),
    );
  }

  void displayWarning() {
    Alert(
      //Displays popup warning to user
      context: context,
      type: AlertType.warning,
      title: "Sorry",
      desc: "Your results don't add up to the number of cards",
      buttons: [
        DialogButton(
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context), //Removes warning
          width: 120,
        )
      ],
    ).show();
  }
}
