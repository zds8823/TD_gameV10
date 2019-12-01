import 'package:flutter/material.dart';

class GameButton {
  final id;
  String text;
  Color bg;
  bool enabled;
  bool tower;
  int plot;
  bool aoe;
  int damage;
  int price;
  String assetString;

  GameButton(
      {this.id, this.text = "", this.bg = Colors.lightGreen,
        this.enabled = true,this.tower = false, this.plot = 0
        , this.aoe = false});
}
