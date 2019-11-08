import 'package:flutter/material.dart';
import 'package:flutter_app/home_page.dart';
//import 'package:flame/game.dart';
import 'dart:ui';
import 'package:flutter/gestures.dart';


void main() async => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primaryColor: Colors.black),
      home: new HomePage(),
    );
  }
}