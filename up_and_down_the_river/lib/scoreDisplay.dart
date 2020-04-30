import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:upanddowntheriver/player.dart';

import 'guessCollection.dart';

class ScoreDisplay extends StatefulWidget {
  final List<Player> currentPlayers;
  final int numberCards;
  final int maxNumberCards;
  final List<int> results;
  final List<int> guesses;
  final int roundNumber;
  ScoreDisplay(
    this.currentPlayers,
    this.numberCards,
    this.maxNumberCards,
    this.results,
    this.guesses,
    this.roundNumber,
  );
  @override
  ScoreDisplayState createState() {
    return ScoreDisplayState(currentPlayers, numberCards, maxNumberCards,
        results, guesses, roundNumber);
  }
}

class ScoreDisplayState extends State<ScoreDisplay> {
  final List<Player> currentPlayers;
  int numberCards;
  final int maxNumberCards;
  final List<int> results;
  final List<int> guesses;
  int roundNumber;
  ScoreDisplayState(
    this.currentPlayers,
    this.numberCards,
    this.maxNumberCards,
    this.results,
    this.guesses,
    this.roundNumber,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scores'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount: currentPlayers.length,
                itemBuilder: displayCurrentPlayer),
          ),
        ],
      ),
      floatingActionButton: actionButtonChanger(),
    );
  }

  Widget displayCurrentPlayer(BuildContext context, int index) {
    calculateScore(index);
    String playerScore = currentPlayers[index].score.toString();
    String heroName = 'hero' + currentPlayers[index].name;
    return Hero(
      tag: heroName,
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: currentPlayers[index].userColor,
          ),
          title: Text(currentPlayers[index].name + ': $playerScore'),
        ),
      ),
    );
  }

  void nextGame() {
    changeCardNumber();
    rearrangePlayers();
    changeToGuessCollection();
  }

  void calculateScore(int index) {
    if (guesses[index] == results[index]) {
      int scoreAddition = 10 + 5 * results[index];
      currentPlayers[index].score += scoreAddition;
    }
  }

  void changeCardNumber() {
    if (roundNumber >= maxNumberCards) {
      numberCards--;
    } else {
      numberCards++;
    }
    roundNumber++;
  }

  void changeToGuessCollection() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GuessCollection(
            currentPlayers, numberCards, maxNumberCards, roundNumber),
      ),
    );
  }

  void restartDialogue() {
    Alert(
      context: context,
      type: AlertType.success,
      title: "Congradulations",
      desc: "You have finished your game",
      buttons: [
        DialogButton(
          child: Text(
            "Restart",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Phoenix.rebirth(context),
          width: 120,
        )
      ],
    ).show();
  }

  void rearrangePlayers() {
    Player tempPlayer = currentPlayers[0];
    currentPlayers.removeAt(0);
    currentPlayers.add(tempPlayer);
  }

  actionButtonChanger() {
    if (roundNumber >= maxNumberCards) {
      if (numberCards == 1) {
        return actionButtonFinish();
      }
    }
    return actionButtonNext();
  }

  actionButtonFinish() {
    return FloatingActionButton.extended(
      onPressed: restartDialogue,
      label: Text('Finish'),
      icon: Icon(Icons.flight_land),
    );
  }

  actionButtonNext() {
    return FloatingActionButton.extended(
      onPressed: nextGame,
      label: Text('Next round'),
      icon: Icon(Icons.done_all),
    );
  }
}
