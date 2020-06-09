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
        title: Text('Enter guesses: $cardNumber cards'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Material(
        child: GridView.builder(
          itemCount: currentPlayers.length,
          itemBuilder: (context, index) {
            return displayPlayers(index); //Builds grid of widgets
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //Sets grid style
            crossAxisCount: 2,
          ),
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
            color: currentPlayers[index].color,
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
                  /* Copyright 2017 Marcin Szalek

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */

                  child: NumberPicker.horizontal(
                    initialValue: guesses[index],
                    minValue: 0,
                    maxValue: cardNumber,
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
    if (guessSum == cardNumber) {
      //Checks to make sure that the guesses don't add up to the number of cards
      displayWarning();
    } else {
      Navigator.of(context).pushReplacement(_createRoute(
          currentPlayers, cardNumber, guesses, maxNumberCards, roundNumber));
    }
  }

  void displayWarning() {
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
    int cardNumber, //Sets up animation to next screen
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

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
