import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  SettingsPageState createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {
  Color tempColor = Colors.grey;
  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(child: Builder(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Settings'),
          ),
          body: Column(
            children: <Widget>[
//              MaterialColorPicker(
//                shrinkWrap: true,
//                selectedColor: tempColor,
//                onMainColorChange: (Color color) {
//                  ThemeData newTheme = ThemeData(primaryColor: Colors.amber);
//                  ThemeSwitcher.of(context).changeTheme(theme: newTheme);
//                },
//              ),
              ThemeSwitcher(
                builder: (context) {
                  return IconButton(
                    onPressed: () {
                      ThemeData newTheme = ThemeData(primaryColor: Colors.red);
                      ThemeSwitcher.of(context).changeTheme(theme: newTheme);
                    },
                    icon: Icon(Icons.brightness_3, size: 25),
                  );
                },
              ),
            ],
          ),
        );
      },
    ));
  }
}
