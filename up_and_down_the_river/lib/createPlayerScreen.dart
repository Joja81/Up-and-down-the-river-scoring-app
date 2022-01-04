import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:upanddowntheriver/player.dart';

class CreatePlayer extends StatefulWidget {
  @override
  CreatePlayerState createState() {
    return CreatePlayerState();
  }
}

class CreatePlayerState extends State<CreatePlayer> {
  final TextEditingController nameController =
      new TextEditingController(); //Controller for name entry which tracks what is entered
  Color userColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create new player'),
      ),
      body: SafeArea(
        child: ListView(children: <Widget>[
          //Creates scrolling set of widgets
          Container(
            padding: EdgeInsets.all(40.0),
            child: Center(
              child: Text(
                'Name',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
                controller: nameController, //Stores what is entered
                onSubmitted: (String str) {
                  createPlayer(context);
                }),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                'Colour',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
          ),
          MaterialColorPicker(
            //Widget to let player pick colour
            shrinkWrap:
                true, //Minimizes extra space widget takes up, otherwise expands to fit space, breaking screen
            allowShades: false,
            selectedColor: userColor,
            onMainColorChange: (Color color) {
              //Changes colour selection on user seleciton
              userColor = color;
            },
            physics: ScrollPhysics(), //Allow scrolling on it
          ),
          SizedBox(
            //Separates out widgets
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                  padding: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Theme.of(context).accentColor,
                  child: Text(
                    'Create player',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    createPlayer(context);
                  }),
            ],
          ),
        ]),
      ),
    );
  }

  void createPlayer(BuildContext context) {
    if (nameController.text.length > 0) {
      //Checks to make sure a name has been entered
      String name = nameController.text; //Gets name from text entry widget
      name = name.trim(); //Removes extra spaces at start/ end
      Navigator.pop(
          context, Player(name, userColor, 0)); //Moves back to start screen
    } else {
      Alert(
        //Displays warning to user
        context: context,
        type: AlertType.error,
        title: "Sorry",
        desc: "Please add a name to the player",
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(
                context), //Moves screen back to create player screen when button pressed
            width: 120,
          )
        ],
      ).show();
    }
  }
}
