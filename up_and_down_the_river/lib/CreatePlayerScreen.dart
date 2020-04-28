import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
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
            Container(
              child: Center(
                child: RaisedButton(
                    child: Text('Add player'),
                    onPressed: () {
                      print(userColor);
                      Navigator.pop(
                          context, Player(nameController.text, userColor, 0));
                    }),
              ),
            )
          ]),
        ));
  }
}
