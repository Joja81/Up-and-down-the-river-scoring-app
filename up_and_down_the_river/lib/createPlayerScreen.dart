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
          MaterialColorPicker(
            shrinkWrap: true,
            allowShades: false,
            selectedColor: userColor,
            onMainColorChange: (Color color) {
              userColor = color;
            },
            physics: ScrollPhysics(), //Allow scrolling on it
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
      String name = nameController.text;
      name = name.trim(); //Removes extra spaces at start/ end
      Navigator.pop(context, Player(name, userColor, 0));
    } else {
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
}
