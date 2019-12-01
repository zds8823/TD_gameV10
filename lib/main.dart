import 'package:flutter/material.dart';
import 'package:flutter_app/home_page.dart';
import 'package:flutter/services.dart';
//import 'package:flame/game.dart';
import 'dart:ui';
import 'package:flutter/gestures.dart';


void main() async => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return new MaterialApp(
      theme: new ThemeData(primaryColor: Colors.blue),
      home: new HomePage(),
    );
  }
}
