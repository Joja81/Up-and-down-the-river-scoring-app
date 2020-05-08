import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:upanddowntheriver/player.dart';
import 'package:upanddowntheriver/scoreDisplay.dart';

class ResultCollection extends StatefulWidget {
  final List<Player> currentPlayers;
  final int numberCards;
  final List<int> guesses;
  final int maxNumberCards;
  final int roundNumber;
  @override
  ResultCollection(this.currentPlayers, this.numberCards, this.guesses,
      this.maxNumberCards, this.roundNumber); //Gets values from last page
  ResultCollectionState createState() {
    return ResultCollectionState(currentPlayers, numberCards, guesses,
        maxNumberCards, roundNumber); //Sends values to state
  }
}

class ResultCollectionState extends State<ResultCollection> {
  final List<Player> currentPlayers;
  final int numberCards;
  final List<int> guesses;
  final int maxNumberCards;
  final int roundNumber;
  ResultCollectionState(this.currentPlayers, this.numberCards, this.guesses,
      this.maxNumberCards, this.roundNumber); //Collects states

  List<int> results;
  @override
  void initState() {
    super.initState();
    results = List.generate(currentPlayers.length,
        (i) => 0); //Creates list of results, sets intital value to 0
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: checkResults,
          icon: Icon(Icons.done_all),
          label: Text("View scores")),
      appBar: AppBar(
        title: Text(
            'Enter results: $numberCards cards'), //Shows how many cards there are
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: GridView.builder(
        itemCount: currentPlayers.length,
        itemBuilder: (context, index) {
          return displayPlayers(index);
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //Sets up grid
          crossAxisCount: 2,
        ),
      ),
    );
  }

  Widget displayPlayers(int index) {
    //Sets up each player display
    String heroName = 'hero' + currentPlayers[index].name;

    return Hero(
      tag: heroName,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: currentPlayers[index].userColor,
          ),
          child: Column(
            children: <Widget>[
              Text(
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
                  child: NumberPicker.horizontal(
                    initialValue: results[index],
                    minValue: 0,
                    maxValue: numberCards,
                    onChanged: (value) => setState(() => results[index] =
                        value), //Updates value as player moves scroller
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
    if (resultSum == numberCards) {
      //Checks to make sure correct number fo results entered
      changeToScore();
    } else {
      displayWarning();
    }
  }

  void changeToScore() {
    //Moves to scores screen
    Navigator.of(context).pushReplacement(_createRoute(currentPlayers,
        numberCards, maxNumberCards, results, guesses, roundNumber));
  }

  Route _createRoute(
    //Sets up transition animation
    List<Player> currentPlayers,
    int numberCards,
    int maxNumberCards,
    List<int> results,
    List<int> guesses,
    int roundNumber,
  ) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ScoreDisplay(
        currentPlayers,
        numberCards,
        maxNumberCards,
        results,
        guesses,
        roundNumber,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void displayWarning() {
    Alert(
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
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }
}
