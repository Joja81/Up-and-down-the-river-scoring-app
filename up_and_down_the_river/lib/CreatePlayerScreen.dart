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
  Color buttonColor = Colors.grey;
  Color userColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create new player'),
        ),
        body: SafeArea(
          child: Column(children: <Widget>[
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
              padding: EdgeInsets.all(40.0),
              child: Center(
                child: Text(
                  'Colour',
                  style: TextStyle(
                    fontSize: 22,
                    color: buttonColor,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: MaterialColorPicker(
                  allowShades: false,
                  onColorChange: (color) => setState(() => userColor = color),
                  onMainColorChange: (color) =>
                      setState(() => userColor = color),
                  selectedColor: userColor,
                ),
              ),
            ),
            RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                padding: EdgeInsets.all(20.0),
                color: Colors.blue,
                child: Text(
                  'Create player',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  if (nameController.text.length > 1) {
                    print(userColor);
                    Navigator.pop(
                        context, Player(nameController.text, userColor, 0));
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
                }),
            Expanded(
              child: SizedBox(),
            ),
          ]),
        ));
  }
}
