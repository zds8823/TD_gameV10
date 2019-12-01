import 'package:flutter/material.dart';
import 'package:flutter_app/game_button.dart';

class Enemy {
  int health = 200;
  double opacity = 0.0;
  double x = 125;
  double y = 70;
  bool spawned = false;
  var _enemyPathX = [15, 18.5, 23, 27];
  var _enemyPathY = [5, 9, 14, 18, 22, 26, 30, 35, 39];

  Enemy();
  Widget build() {
    return new Container(
      width: 50,
      height: 50,
      decoration: new BoxDecoration(
        image: DecorationImage(
          image: new AssetImage(
              'assets/images/enemy.png'
          ),
          fit: BoxFit.fill,
        ),
      ),
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
          if (buttonsList[enemyPath[i] - 7].aoe == true)
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
    x = width * 12.3;
    y = height * 6;
    spawned = true;
    health = enemyHealth;
    opacity = 1.0;
  }

  // We don't actually destroy enemies, just hide and unhide when needed again
  void despawn(double height){
    spawned = false;
    y = height * 7;
    opacity = 0.0;
  }
}
