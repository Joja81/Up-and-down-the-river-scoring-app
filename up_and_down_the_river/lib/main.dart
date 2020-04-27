import 'package:flutter/material.dart';
import 'package:upanddowntheriver/player.dart';

void main() {
  runApp(MaterialApp(
    title: 'Up and down the river',
    home: SelectPlayer(),
  ));
}

class SelectPlayer extends StatefulWidget {
  @override
  SelectPlayerState createState() {
    return SelectPlayerState();
  }
}

class SelectPlayerState extends State<SelectPlayer> {
  //Store player info
  List<Player> currentPlayers = [
    Player('Joshua', Colors.red, 0),
  ];

  List<Widget> playerWidgets = [
    Container(
      padding: EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[Text('Add player'), Icon(Icons.add)],
      ),
    )
  ];

  int i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Up and down the river scorer'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(children: <Widget>[
          Container(
            child: RaisedButton(
              onPressed: buttonPressed,
            ),
          ),
          Column(
            children: playerWidgets,
            //TODO Add in listview builder
          ),
        ]),
      ),
    );
  }

  void buttonPressed() {
//    int i = 0;
////    Widget widget = Padding(
////      padding: const EdgeInsets.all(15.0),
////      child: GestureDetector(
////        child: Container(
////          decoration: new BoxDecoration(
////            borderRadius: new BorderRadius.all(Radius.circular(20.0)),
////            color: currentPlayers[i].userColor,
////          ),
////          child: Row(children: <Widget>[
////            Center(child: Text(currentPlayers[i].name)),
////          ]),
////        ),
////      ),
////    );
////
////    setState(() {
////      playerWidgets.add(widget);
////    });
    setState(() {
      playerWidgets.insert(0, Text('Hello?'));
    });
    print(playerWidgets.length);
  }
}
