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
  final TextEditingController nameController = new TextEditingController();
  Color userColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create new player'),
      ),
      body: SafeArea(
        child: ListView(children: <Widget>[
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
              controller: nameController,
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                'Colour',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 60,
            ),
            child: RaisedButton(
              shape: CircleBorder(),
              padding: EdgeInsets.all(50.0),
              color: userColor,
              child: Text(
                "Select colour",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return displayDialog(context);
                  },
                );
              },
            ),
          ),
          SizedBox(
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
      print(userColor);
      Navigator.pop(context, Player(nameController.text, userColor, 0));
    } else {
      Alert(
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
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }
  }

  Dialog displayDialog(BuildContext context) {
    Color tempColor = userColor;
    return Dialog(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: MaterialColorPicker(
              onMainColorChange: (Color color) {
                tempColor = color;
              },
              allowShades: false,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              margin: EdgeInsets.all(20.0),
              child: Text("Select"),
            ),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              setState(() {
                userColor = tempColor;
              });
              Navigator.of(context).pop();
            },
          ),
          Expanded(
            child: SizedBox(
              height: 10,
            ),
          ),
        ],
      ),
    );
  }
}
