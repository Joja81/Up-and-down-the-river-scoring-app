import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:upanddowntheriver/player.dart';
import 'package:upanddowntheriver/resultCollection.dart';

class GuessCollection extends StatefulWidget {
  final List<Player> currentPlayers;
  final int cardNumber;
  final int maxNumberCards;
  final int roundNumber;
  @override
  GuessCollection(
    this.currentPlayers, //Getting variables from last page
    this.cardNumber,
    this.maxNumberCards,
    this.roundNumber,
  );
  GuessCollectionState createState() {
    return GuessCollectionState(
      //Sending variables to state
      this.currentPlayers,
      this.cardNumber,
      this.maxNumberCards,
      this.roundNumber,
    );
  }
}

class GuessCollectionState extends State<GuessCollection> {
  final List<Player> currentPlayers;
  final int cardNumber;
  final int maxNumberCards;
  final int roundNumber;
  GuessCollectionState(
    //Getting variables from createState
    this.currentPlayers,
    this.cardNumber,
    this.maxNumberCards,
    this.roundNumber,
  );

  List<int> guesses; //Define guesses variable
  @override
  void initState() {
    //Run on initiation
    super.initState();
    guesses = List.generate(
        currentPlayers.length,
        (i) =>
            0); //Create list for guesses, all set as 0 as this is what appears on the selectors initially
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //Catches if back button is pressed
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          //Floating button to allow moving to next screen
          onPressed: () {
            moveToResults();
          },
          icon: Icon(Icons.done_all),
          label: Text("Enter results"),
        ),
        appBar: AppBar(
          title: Text('Enter guesses: $cardNumber cards'),
          centerTitle: true,
        ),
        body: Material(
          child: GridView.builder(
            //Creates gird of widgets
            itemCount: currentPlayers.length,
            itemBuilder: (context, index) {
              return displayPlayers(index); //Builds grid of widgets
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //Sets grid style
              crossAxisCount: 2, //How many players per line
            ),
          ),
        ),
      ),
    );
  }

  Widget displayPlayers(int index) {
    //Add position of player to the screen
    int numberPlayers = currentPlayers.length;
    if (index > 0 && index < (numberPlayers - 1)) {
      //Labels each player with position
      String frontText = (index + 1).toString() + '. ';
      return playerContainer(index,
          frontText); //Sends front text to method which creates widget for player
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
        //Unifies the widgets inside it
        type: MaterialType.transparency,
        child: Container(
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: currentPlayers[index].color,
          ),
          child: Column(
            //Stacks the widgets
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
                  child: NumberPicker(
                    //Slider for number selection
                    value:
                        guesses[index], //Sets what the current value is
                    minValue: 0,
                    axis: Axis.horizontal,
                    maxValue:
                        cardNumber, //Stops the user from entering number larger then the number of cards
                    onChanged: (value) => setState(() => guesses[index] =
                        value), //Sets value for guess when number is changed
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
    if (guessSum == cardNumber) {
      //Checks to make sure that the guesses don't add up to the number of cards

      displayWarning(); //Sends warning to user and stops screen change if the guess add up
    } else {
      Navigator.of(context).pushReplacement(_createRoute(
          currentPlayers,
          cardNumber,
          guesses,
          maxNumberCards,
          roundNumber)); //Moves to result collection screen and deletes current screen. CreateRoute sets up annimation
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
          onPressed: () => Navigator.pop(context), //Removes warning
          width: 120,
        )
      ],
    ).show();
  }
}

Route _createRoute(
    //Sets up screen change and annimation for it
    List<Player> currentPlayers,
    int cardNumber,
    List<int> guesses,
    int maxNumberCards,
    int roundNumber) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ResultCollection(
        currentPlayers, cardNumber, guesses, maxNumberCards, roundNumber),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end)
          .chain(CurveTween(curve: curve)); //Style and data for animation

      return SlideTransition(
        //Action for animation
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
