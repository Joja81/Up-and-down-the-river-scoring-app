import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:upanddowntheriver/player.dart';
import 'package:upanddowntheriver/resultCollection.dart';

class GuessCollection extends StatefulWidget {
  final List<Player> currentPlayers;
  final int numberCards;
  final int maxNumberCards;
  final int roundNumber;
  @override
  GuessCollection(
    this.currentPlayers, //Getting variables from last page
    this.numberCards,
    this.maxNumberCards,
    this.roundNumber,
  );
  GuessCollectionState createState() {
    return GuessCollectionState(
      //Sending variables to state
      this.currentPlayers,
      this.numberCards,
      this.maxNumberCards,
      this.roundNumber,
    );
  }
}

class GuessCollectionState extends State<GuessCollection> {
  final List<Player> currentPlayers;
  final int numberCards;
  final int maxNumberCards;
  final int roundNumber;
  GuessCollectionState(
    //Getting variables from createState
    this.currentPlayers,
    this.numberCards,
    this.maxNumberCards,
    this.roundNumber,
  );

  List<int> guesses;
  @override
  void initState() {
    super.initState();
    guesses = List.generate(
        currentPlayers.length,
        (i) =>
            0); //Create list for guesses, all set as 0 as this is what appears on the selectors initially
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            moveToResults();
          },
          icon: Icon(Icons.done_all),
          label: Text("Enter results")),
      appBar: AppBar(
        title: Text('Enter guesses: $numberCards cards'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: GridView.builder(
        itemCount: currentPlayers.length,
        itemBuilder: (context, index) {
          return displayPlayers(index);
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //Sets grid style
          crossAxisCount: 2,
        ),
      ),
    );
  }

  Widget displayPlayers(int index) {
    //Add position of player to the screen
    int numberPlayers = currentPlayers.length;
    if (index > 0 && index < (numberPlayers - 1)) {
      String frontText = (index + 1).toString() + '. ';
      return playerContainer(index, frontText);
    } else if (index == 0) {
      return playerContainer(index, 'First: ');
    } else {
      return playerContainer(index, 'Last: ');
    }
  }

  Widget playerContainer(int index, String start) {
    String heroName =
        'hero' + currentPlayers[index].name; //Name for animation store

    return Hero(
      tag: heroName, //Animation identifier
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: currentPlayers[index].userColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                start + currentPlayers[index].name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Theme(
                data: ThemeData(
                  accentColor: Colors.white,
                ),
                child: Expanded(
                  child: NumberPicker.horizontal(
                    initialValue: guesses[index],
                    minValue: 0,
                    maxValue: numberCards,
                    onChanged: (value) => setState(
                        () => guesses[index] = value), //Sets value for guess
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void moveToResults() {
    int guessSum = 0;
    for (int i = 0; i < guesses.length; ++i) {
      //Sums up guesses
      guessSum += guesses[i];
    }
    if (guessSum == numberCards) {
      //Checks to make sure that the guesses don't add up to the number of cards
      displayWarning();
    } else {
      Navigator.of(context).pushReplacement(_createRoute(
          currentPlayers, numberCards, guesses, maxNumberCards, roundNumber));
    }
  }

  void displayWarning() {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Sorry",
      desc:
          "Your guesses add up to the number of cards, the last player must change his guess",
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

Route _createRoute(
    List<Player> currentPlayers,
    int numberCards, //Sets up animation to next screen
    List<int> guesses,
    int maxNumberCards,
    int roundNumber) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ResultCollection(
        currentPlayers, numberCards, guesses, maxNumberCards, roundNumber),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
