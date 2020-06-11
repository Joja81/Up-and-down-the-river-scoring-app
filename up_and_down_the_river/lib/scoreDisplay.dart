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
    this.roundNumber, //Load variables
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
    return WillPopScope(
      onWillPop: () {
        return new Future(() => false); //Catches back button
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Scores'),
        ),
        body: displayPlayers(), //Dispalys list of players
        floatingActionButton:
            actionButtonChanger(), //Directs to method which changes action button depending on if last round or not
      ),
    );
  }

  Widget displayPlayers() {
    calculateScore();
    sortedPlayers = sortPlayers(); //List of palyers sorted by score
    return ListView.builder(
      //Widget that holds all the players and there scores
      itemCount: currentPlayers.length,
      itemBuilder:
          displayCurrentPlayer, //Creates individual widget for each player
    );
  }

  Widget displayCurrentPlayer(BuildContext context, int index) {
    //Creates widget for player
    String heroName = 'hero' + sortedPlayers[index].name; //Animation identifier
    int score = sortedPlayers[index].score;
    return Hero(
      tag: heroName,
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: sortedPlayers[index].color, //Colour of player icon
          ),
          title: Text(
              sortedPlayers[index].name + ': $score'), //Displays name and score
        ),
      ),
    );
  }

  void nextRound() {
    //Sets up for next round of game
    changeCardNumber();
    rearrangePlayers();
    changeToGuessCollection();
  }

  void calculateScore() {
    //Calculates score of each player
    for (int i = 0; i < currentPlayers.length; i++) {
      //Loops through each player
      if (guesses[i] == results[i]) {
        //Checks if player guesssed correct
        int scoreAddition = 10 + results[i] * 5; //Calculates addition to score
        currentPlayers[i].score += scoreAddition; //Adds addition to main score
      }
    }
  }

  void changeCardNumber() {
    if (roundNumber >= maxNumberCards) {
      //Checks if game is going up or down the river then adjusts card number
      cardNumber--;
    } else {
      cardNumber++;
    }
    roundNumber++; //Always adds to round number
  }

  void changeToGuessCollection() {
    //Shifts user to guess collection screen and deletes current screen.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GuessCollection(
            currentPlayers, cardNumber, maxNumberCards, roundNumber),
      ),
    );
  }

  void restartDialogue() {
    //Displays when game is finished
    Alert(
      //Popup menu congratulating user
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
            Navigator.pop(context);
            resetPlayers(); //Deletes scores from players
            goToStartScreen(); //Moves to start screen
          },
          width: 120,
        )
      ],
    ).show();
  }

  void rearrangePlayers() {
    Player tempPlayer = currentPlayers[0]; //Stores first player in temp storage
    currentPlayers.removeAt(0); //Removes first player
    currentPlayers.add(tempPlayer); //Adds first player to back of list
  }

  actionButtonChanger() {
    if (roundNumber >= maxNumberCards && cardNumber == 1) {
      //Checks if the game is finished
      return actionButtonFinish(); //Displays finish message if game is done
    }
    return actionButtonNext(); //Other wise displays next round
  }

  actionButtonFinish() {
    //Floating button that appears if game is done
    return FloatingActionButton.extended(
      onPressed: restartDialogue, //Displays message to restart game
      label: Text('Finish'),
      icon: Icon(Icons.flight_land),
    );
  }

  actionButtonNext() {
    //Floating button to go to next round
    return FloatingActionButton.extended(
      onPressed: nextRound, //Sets up next round
      label: Text('Next round'),
      icon: Icon(Icons.done_all),
    );
  }

  List<Player> sortPlayers() {
    //Sorts the players by score
    List<Player> temporarySortPlayer = new List<Player>();

    for (int i = 0; i < currentPlayers.length; i++) {
      //Adds current players to temporary list
      temporarySortPlayer.add(currentPlayers[i]);
    }

    List<Player> currentlySortedPlayers = new List<Player>();

    while (temporarySortPlayer.length > 1) {
      Player highestScorePlayer =
          temporarySortPlayer[0]; //Initally sets first player to be highest
      int highestScoreIndex = 0;
      for (int i = 1; i < temporarySortPlayer.length; i++) {
        //Runs thorugh temp list
        if (temporarySortPlayer[i].score > highestScorePlayer.score) {
          //Checks if current player is higher then current highest player
          highestScorePlayer = temporarySortPlayer[
              i]; //Makes current player highest score player if it is
          highestScoreIndex = i; //Stores index of currently highest player
        }
      }
      currentlySortedPlayers
          .add(highestScorePlayer); //Adds player to end of currentlySorted list
      temporarySortPlayer
          .removeAt(highestScoreIndex); //Removes player from temp list
    }
    currentlySortedPlayers.add(temporarySortPlayer[0]); //Adds last player

    return currentlySortedPlayers;
  }

  void resetPlayers() {
    for (int i = 0; i < currentPlayers.length; i++) {
      //Sets all players score to 0 for restart of app
      currentPlayers[i].score = 0;
    }
  }

  void goToStartScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            StartScreen(currentPlayers), //Goes to start screen
      ),
    );
  }
}
