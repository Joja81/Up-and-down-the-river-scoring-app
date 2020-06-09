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
        (i) => 0); //Creates list of results, sets intital value to 0
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            onPressed: checkResults,
            icon: Icon(Icons.done_all),
            label: Text("View scores")),
        appBar: AppBar(
          title: Text(
              'Enter results: $cardNumber cards'), //Shows how many cards there are
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Material(
          child: GridView.builder(
            itemCount: currentPlayers.length,
            itemBuilder: (context, index) {
              return displayPlayers(index);
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //Sets up grid
              crossAxisCount: 2,
            ),
          ),
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
            color: currentPlayers[index].color,
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
                  /* Copyright 2017 Marcin Szalek

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */

                  child: NumberPicker.horizontal(
                    initialValue: results[index],
                    minValue: 0,
                    maxValue: cardNumber,
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
    if (resultSum == cardNumber) {
      //Checks to make sure correct number fo results entered
      changeToScore();
    } else {
      displayWarning();
    }
  }

  void changeToScore() {
    //Moves to scores screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ScoreDisplay(currentPlayers, cardNumber,
            maxNumberCards, results, guesses, roundNumber),
      ),
    );
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
