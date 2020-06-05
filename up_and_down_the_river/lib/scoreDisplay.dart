import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:upanddowntheriver/player.dart';
import 'package:upanddowntheriver/startScreen.dart';

import 'guessCollection.dart';

class ScoreDisplay extends StatefulWidget {
  final List<Player> currentPlayers;
  final int cardNumber;
  final int maxNumberCards;
  final List<int> results;
  final List<int> guesses;
  final int roundNumber;
  ScoreDisplay(
    this.currentPlayers,
    this.cardNumber,
    this.maxNumberCards,
    this.results,
    this.guesses,
    this.roundNumber,
  );
  @override
  ScoreDisplayState createState() {
    return ScoreDisplayState(currentPlayers, cardNumber, maxNumberCards,
        results, guesses, roundNumber);
  }
}

class ScoreDisplayState extends State<ScoreDisplay> {
  List<Player> sortedPlayers = new List<Player>();

  final List<Player> currentPlayers;
  int cardNumber;
  final int maxNumberCards;
  final List<int> results;
  final List<int> guesses;
  int roundNumber;
  ScoreDisplayState(
    this.currentPlayers,
    this.cardNumber,
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
      body: displayPlayers(),
      floatingActionButton: actionButtonChanger(),
    );
  }

  Widget displayPlayers() {
    calculateScore();
    sortedPlayers = sortPlayers();
    return ListView.builder(
      itemCount: currentPlayers.length,
      itemBuilder: displayCurrentPlayer,
    );
  }

  Widget displayCurrentPlayer(BuildContext context, int index) {
    String heroName = 'hero' + sortedPlayers[index].name;
    int score = sortedPlayers[index].score;
    return Hero(
      tag: heroName,
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: sortedPlayers[index].color,
          ),
          title: Text(sortedPlayers[index].name + ': $score'),
        ),
      ),
    );
  }

  void nextGame() {
    changeCardNumber();
    rearrangePlayers();
    changeToGuessCollection();
  }

  void calculateScore() {
    for (int i = 0; i < currentPlayers.length; i++) {
      if (guesses[i] == results[i]) {
        int scoreAddition = 10 + results[i] * 5;
        currentPlayers[i].score += scoreAddition;
      }
    }
  }

  void changeCardNumber() {
    if (roundNumber >= maxNumberCards) {
      //Checks if game is going up or down the river
      cardNumber--;
    } else {
      cardNumber++;
    }
    roundNumber++;
  }

  void changeToGuessCollection() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GuessCollection(
            currentPlayers, cardNumber, maxNumberCards, roundNumber),
      ),
    );
  }

  void restartDialogue() {
    Alert(
      context: context,
      type: AlertType.success,
      title: "Congratulations",
      desc: "You have finished your game",
      buttons: [
        DialogButton(
          child: Text(
            "Restart",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            resetPlayers();
            goToStartScreen();
          },
          width: 120,
        )
      ],
    ).show();
  }

  void rearrangePlayers() {
    Player tempPlayer =
        currentPlayers[0]; //Puts the player who was first last time at the end
    currentPlayers.removeAt(0);
    currentPlayers.add(tempPlayer);
  }

  actionButtonChanger() {
    if (roundNumber >= maxNumberCards && cardNumber == 1) {
      //Checks if the game is finished
      return actionButtonFinish();
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

  List<Player> sortPlayers() {
    List<Player> temporarySortPlayer = new List<Player>();

    for (int i = 0; i < currentPlayers.length; i++) {
      temporarySortPlayer.add(currentPlayers[i]);
    }

    List<Player> currentlySortedPlayers = new List<Player>();

    while (temporarySortPlayer.length > 1) {
      print(temporarySortPlayer.length);
      Player highestScorePlayer = temporarySortPlayer[0];
      int highestScoreIndex = 0;
      for (int i = 1; i < temporarySortPlayer.length; i++) {
        if (temporarySortPlayer[i].score > highestScorePlayer.score) {
          highestScorePlayer = temporarySortPlayer[i];
          highestScoreIndex = i;
        }
      }
      print("before add");
      currentlySortedPlayers.add(highestScorePlayer);
      temporarySortPlayer.removeAt(highestScoreIndex);
      print("after loop");
    }
    print(temporarySortPlayer.length);
    currentlySortedPlayers.add(temporarySortPlayer[0]);

    return currentlySortedPlayers;
  }

  void resetPlayers() {
    for (int i = 0; i < currentPlayers.length; i++) {
      currentPlayers[i].score = 0;
    }
  }

  void goToStartScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => StartScreen(currentPlayers),
      ),
    );
  }
}
