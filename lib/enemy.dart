import 'package:flutter/material.dart';
import 'package:flutter_app/game_button.dart';

class Enemy {
  int health = 200;
  Color enemyColor = Colors.black.withOpacity(0.0);
  double x = 125;
  double y = 70;
  bool spawned = false;
  var _enemyPathX = [17, 21.5, 26, 27];
  var _enemyPathY = [9.5, 14, 18.5, 23, 27.5, 32, 36.5, 41, 45.5];

  Enemy();
  Widget build() {
    return new Container(
      padding: const EdgeInsets.all(8.0),
      width: 20,
      height: 20,
      color: enemyColor,
    );
  }

  int checkDamage(double width, double height, List<GameButton> buttonsList, List<int> enemyPath) {
    if (x < width * 27) {
      for (int i = 0; i <= 3; i++) {
        if (x <= width * _enemyPathX[i]){
          // Check squares about, below and in front of for tower
          if (buttonsList[enemyPath[i] + 1].tower == true)
            health -= buttonsList[enemyPath[i] + 1].damage;
          if (buttonsList[enemyPath[i] + 8].tower == true)
            health -= buttonsList[enemyPath[i] + 8].damage;
          if (buttonsList[enemyPath[i] - 8].tower == true)
            health -= buttonsList[enemyPath[i] - 8].damage;

          // Check for AOE damage
          if (buttonsList[enemyPath[i] + 9].aoe == true)
            health -= buttonsList[enemyPath[i] + 9].damage;
          if (buttonsList[enemyPath[i] - 9].aoe == true)
            health -= buttonsList[enemyPath[i] - 9].damage;
          if (buttonsList[enemyPath[i] + 7].aoe == true)
            health -= buttonsList[enemyPath[i] + 7].damage;
          if (buttonsList[enemyPath[i] -7].aoe == true)
            health -= buttonsList[enemyPath[i] - 7].damage;
          break;
        }
      }
    } else if (y < height * 44){
      for (int j = 0; j < 9; j++) {
        if (y <= height * _enemyPathY[j]) {
          // Check squares to the left, right and below for towers
          if (buttonsList[enemyPath[j + 3] + 1].tower == true)
            health -= buttonsList[enemyPath[j + 3] + 1].damage;
          if (buttonsList[enemyPath[j + 3] - 1].tower == true)
            health -= buttonsList[enemyPath[j + 3] - 1].damage;
          if (buttonsList[enemyPath[j + 3] - 8].tower == true)
            health -= buttonsList[enemyPath[j + 3] - 8].damage;

          // Check for AOE damage
          if (buttonsList[enemyPath[j + 3] + 9].aoe == true)
            health -= buttonsList[enemyPath[j + 3] + 9].damage;
          if (buttonsList[enemyPath[j + 3] - 9].aoe == true)
            health -= buttonsList[enemyPath[j + 3] - 9].damage;
          if (buttonsList[enemyPath[j + 3] + 7].aoe == true)
            health -= buttonsList[enemyPath[j + 3] + 7].damage;
          if (buttonsList[enemyPath[j + 3] - 7].aoe == true)
            health -= buttonsList[enemyPath[j + 3] - 7].damage;
          break;
        }
      }
    }
  }

  void spawn(double width, double height, int enemyHealth){
    enemyColor = Colors.black;
    x = width * 12.5;
    y = height * 7;
    spawned = true;
    health = enemyHealth;
  }

  // We don't actually destroy enemies, just hide and unhide when needed again
  void despawn(double height){
    enemyColor = Colors.white.withOpacity(0.0);
    spawned = false;
    y = height * 7;
  }
}
