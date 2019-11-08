
import 'package:flutter/material.dart';

class GameButton {
  final id;
  String text;
  Color bg;
  bool enabled;
  bool tower;
  bool aoe;
  int damage;
  int price;

  GameButton(
      {this.id, this.text = "", this.bg = Colors.grey, this.enabled = true, this.tower = false, this.aoe = false});
}