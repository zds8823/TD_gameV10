import 'dart:math';
import 'package:giffy_dialog/giffy_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_app/custom_dailog.dart';
import 'package:flutter_app/enemy.dart';
import 'package:flutter_app/game_button.dart';
import 'dart:async';
//import 'package:flutter_app/components/time.dart';
//import 'package:flutter_app/components/dependencies.dart';
//import 'package:flutter_app/components/map.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GameButton> buttonsList;
  var player1;
  var player2;
  var activePlayer;
  Timer _timer;
  int _countDown = 120;
  int _money = 80;
  int _lives = 10;
  int _score = 0;
  int _wave = 1;
  var _enemyPath = [11, 12, 13, 14, 22, 30, 38, 46, 54, 62, 70, 78];
  int _nextEnemyHealth = 300;
  int _enemyHealth = 150;
  bool start = true;

  var enemyArray = [new Enemy(), new Enemy(), new Enemy(), new Enemy(),
    new Enemy(), new Enemy(), new Enemy(), new Enemy(), new Enemy(),
    new Enemy()];

  double screenHeight(BuildContext context, double div) {
    return MediaQuery.of(context).size.height / div;
  }

  double screenWidth(BuildContext context, double div) {
    return MediaQuery.of(context).size.width / div;
  }

  void enemyMovement(Enemy enemy, double moveByX, double moveByY){
    double finalX = moveByX * 27;
    double finalY = moveByY * 44;
    enemy.checkDamage(moveByX, moveByY, buttonsList, _enemyPath);

    // Check if enemy is alive
    if (enemy.health > 0) {
      if (enemy.x <= finalX)
        enemy.x += moveByX;
      else if (enemy.y < finalY)
        enemy.y += moveByY;

      // If it gets to the end, destroy and subtract a life
      if (enemy.y >= finalY) {
        _lives -= 1;
        enemy.despawn(moveByY);
      }
    } else {
      // Give score and money for killing enemy, make next enemies stronger
      _score += 2;
      _money += 5;
      if (_enemyHealth < _nextEnemyHealth)
        _enemyHealth += 20;
      else
        _enemyHealth = _nextEnemyHealth;
      enemy.despawn(moveByY);
    }
  }

  // does time and enemy spawn right now
  void startTimer() {
    const duration = const Duration(seconds: 1);
    int checkSpawn = 0;
    int currentEnemy = 0;
    double moveByX = screenWidth(context, 36);
    double moveByY = screenHeight(context, 69.2);

    enemyArray[currentEnemy].spawn(moveByX, moveByY, _enemyHealth);

    _timer = new Timer.periodic(
      duration,
          (Timer timer) => setState(
            () {
          if (_countDown < 1) {
            if (_wave < 5)
              resetWave(moveByX, moveByY);
            else
              timer.cancel();
          } else {
            // Spawns new enemies every 5 seconds
            if (checkSpawn < 5)
              checkSpawn++;
            else {
              checkSpawn = 0;
              currentEnemy++;
              if (currentEnemy == 10)
                currentEnemy = 0;

              if (_countDown >= 44)
                enemyArray[currentEnemy].spawn(moveByX, moveByY, _enemyHealth);
            }

            // Movement for all spawned enemies
            for (int i = 0; i < 10; i++) {
              if (enemyArray[i].spawned == true)
                enemyMovement(enemyArray[i], moveByX, moveByY);
            }

            _countDown = _countDown - 1;
          }
        },
      ),
    );
  }


  void resetWave(double moveByX, double moveByY) {
    for (int i = 0; i < 10; i++)
      enemyArray[i].despawn(moveByY);
    _enemyHealth = _nextEnemyHealth;
    _nextEnemyHealth += 150;
    enemyArray[0].spawn(moveByX, moveByY, _enemyHealth);
    _countDown = 120;
    _money += 50;
    _wave++;
  }

  void setButtons(){
    for (int j = 0; j < 96; j++) {

      buttonsList[j].assetString = 'assets/images/plot.PNG';
    }
    buttonsList[10].bg = Colors.cyanAccent;
    buttonsList[10].assetString = 'assets/images/tp.png';
    buttonsList[86].bg = Colors.pink;
    buttonsList[86].assetString = 'assets/images/castle.png';
    buttonsList[10].enabled = false;
    buttonsList[86].enabled = false;
    buttonsList[10].plot = 5;
    buttonsList[86].plot = 5;

    for (int i = 0; i < 12; i++) {
      buttonsList[_enemyPath[i]].enabled = false;
      buttonsList[_enemyPath[i]].plot = 5;

      buttonsList[_enemyPath[i]].bg = Colors.brown;
      buttonsList[_enemyPath[i]].enabled = false;
      buttonsList[_enemyPath[i]].assetString = 'assets/images/dirt.png';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buttonsList = doInit();
    setButtons();
  }

  List<GameButton> doInit() {
    player1 = new List();
    player2 = new List();
    activePlayer = 1;

    var gameButtons = <GameButton>[
      for (int i = 1; i <= 96; i++)
        new GameButton(id: i),

    ];

    return gameButtons;
  }

  void playGame(GameButton gb) {


    setState(() {
      buttonsList[gb.id].enabled = true;



    if (gb.tower == true && _money >= 20){
      showDialog(
          context: context,builder: (_) => AssetGiffyDialog(
        image: Image.asset(
          'assets/images/up.gif',
          fit: BoxFit.cover,
        ),
        title: Text('Would you like to upgrade?',
          style: TextStyle(
              fontSize: 22.0, fontWeight: FontWeight.w600),
        ),
        description: Text(
          "Press Upgrade to improve tower damage or Cancel to exit window",
          textAlign: TextAlign.center,
          style: TextStyle(),
        ),

        buttonOkText: Text("Upgrade",
          textAlign: TextAlign.center,
          style: TextStyle(),
        ),
        onOkButtonPressed: () {
          // upgrade stuff here
          if (_money >= 20) {
            gb.price = 20;
            gb.damage = gb.damage + 10;
            _money -= gb.price;
          }
          Navigator.of(context, rootNavigator: true).pop('dialog');
        },
      ) );

    }

      if (tower >= 1&& gb.plot <= 4) {


        if (tower == 1 && _money >= 10 && gb.tower == false) {
          //change these colors to sprites
          gb.bg = Colors.brown;
          gb.tower = true;
          gb.damage = 5;
          gb.price = 10;
          gb.plot = 1;
          tower = 0;
          gb.assetString = 'assets/images/towerplot7.png';
          _money -= gb.price;

        }
        if (tower == 2 && _money >= 25 && gb.plot == 0) {
          gb.bg = Colors.brown;
          gb.tower = true;
          gb.damage = 5;
          gb.aoe = true;
          gb.price = 25;
          gb.plot = 2;
          tower = 0;
          gb.assetString = 'assets/images/towerplot4.png';
          _money -= gb.price;

        }
        if (tower == 3 && _money >= 30 && gb.plot == 0) {
          gb.bg = Colors.brown;
          gb.tower = true;
          gb.damage = 10;
          gb.price = 30;
          gb.plot = 3;
          tower = 0;
          gb.assetString = 'assets/images/towerplot2.png';
          _money -= gb.price;

        }
        if (tower == 4 && _money >= 45 && gb.plot == 0) {
          gb.bg = Colors.brown;
          gb.tower = true;
          gb.damage = 10;
          gb.aoe = true;
          gb.price = 45;
          gb.plot = 4;
          tower = 0;
          gb.assetString = 'assets/images/towerplot6.png';
          _money -= gb.price;

        }

      }


      gb.enabled = false;
      int winner = checkWinner();

      if (winner == -1) {
        if (buttonsList.every((p) => p.text != "")) {

          showDialog(
              context: context,
              builder: (_) => new CustomDialog("Game lost",
                  "Press the reset button to start again.", resetGame)
          );
        }
        else {
          activePlayer == 2 ? autoPlay() : null;
        }
      }
    });

  }

  void autoPlay() {
    var emptyCells = new List();
    var list = new List.generate(96, (i) => i + 1);
    for (var cellID in list) {
      if (!(player1.contains(cellID))) {
      }
    }

    var r = new Random();
    var randIndex = r.nextInt(emptyCells.length-1);
    var cellID = emptyCells[randIndex];
    int i = buttonsList.indexWhere((p)=> p.id == cellID);
    playGame(buttonsList[i]);
  }

  int checkWinner() {
    var winner = -1;
    if (_lives == 0) {
      winner = 1;
    }

    if (_lives == 0) {
      showDialog(
          context: context,
          builder: (_) => new CustomDialog("You Lost",
              "Press the reset button to start again.", resetGame));
    }
    return winner;
  }

//Sets the squares to the tower type
  var tower = 0;

  void settower1(){
    tower = 1;
  }
  void settower2(){
    tower = 2;
  }
  void settower3(){
    tower = 3;
  }
  void settower4(){
    tower = 4;
  }

  void resetGame() {
    if (Navigator.canPop(context)) Navigator.pop(context);
    setState(() {
      buttonsList = doInit();

    }
    );
  }

  @override
  Widget build(BuildContext context) {
    buttonsList[10].bg = Colors.cyanAccent;
    buttonsList[86].bg = Colors.pink;

    if (start == true) {
      startTimer();
      start = false;
    }


    return new Scaffold(
       //backgroundColor: Colors.brown,

        appBar: new AppBar(
          title: new Text("Medieval TD"),
        ),

        body: new Stack(

          children: <Widget> [
            Column(

              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                Center(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Text(
                        "Timer: $_countDown",
                      ),
                      new Text(
                        "Score: $_score",
                      ),
                      new Text(
                        "Lives: $_lives",
                      ),
                      new Text(
                        "Money: $_money",
                      ),
                      new Text(
                          "Wave: $_wave"
                      )
                    ],
                  ),
                ),

                new Expanded(

                child: GridView.builder(
                    padding: const EdgeInsets.all(1.0),
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 8,

                        crossAxisSpacing: 1.0,
                        mainAxisSpacing: 1.0),
                    itemCount: buttonsList.length,
                    itemBuilder: (context, i) => new SizedBox(
                      width: 1.0,
                      height: 1.0,
                      child: new RaisedButton(
                        padding: const EdgeInsets.all(0),

                        onPressed:() => playGame(buttonsList[i]),

                        child: Image.asset(
                          buttonsList[i].assetString,
                        ),
                        color: buttonsList[i].bg,
                        disabledColor: buttonsList[i].bg,

                      ),
                    ),
                  ),
                ),
                Center(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new FlatButton(
                        child: Image.asset(
                          "assets/images/tower7.png",
                          width: 30,
                          fit: BoxFit.cover,
                        ),
                        color: Colors.red,
                        padding: const EdgeInsets.all(20.0),
                        onPressed: settower1,
                      ),
                      new RaisedButton(
                        child: Image.asset(
                          "assets/images/tower4.png",
                          width: 30,
                          fit: BoxFit.cover,
                        ),

                        color: Colors.green,
                        padding: const EdgeInsets.all(20.0),
                        onPressed: settower2,
                      ),
                      new RaisedButton(
                        child: Image.asset(
                          "assets/images/tower2.png",
                          width: 30,
                          fit: BoxFit.cover,
                        ),

                        color: Colors.yellow,
                        padding: const EdgeInsets.all(20.0),
                        onPressed: settower3,
                      ),
                      new RaisedButton.icon(elevation: 1.0,
                          icon: Image.asset('assets/images/tower6.png',
                            width: 15,height: 15,),

                          color: Colors.blue,

                          onPressed: settower4,

                          label: Text("Add Team Image",style: TextStyle(
                              color: Colors.white, fontSize: 16.0))

                      )
                    ],
                  ),
                ),
              ],
            ),

            // All enemies spawned and hidden at beginning, spawned when needed
            Opacity(
              opacity: enemyArray[0].opacity,
              child: new Transform.translate(
                offset: Offset(enemyArray[0].x, enemyArray[0].y),
                child: enemyArray[0].build(),
              ),
            ),
            Opacity(
              opacity: enemyArray[1].opacity,
              child: new Transform.translate(
                offset: Offset(enemyArray[1].x, enemyArray[1].y),
                child: enemyArray[1].build(),
              ),
            ),
            Opacity(
              opacity: enemyArray[2].opacity,
              child: new Transform.translate(
                offset: Offset(enemyArray[2].x, enemyArray[2].y),
                child: enemyArray[2].build(),
              ),
            ),
            Opacity(
              opacity: enemyArray[3].opacity,
              child: new Transform.translate(
                offset: Offset(enemyArray[3].x, enemyArray[3].y),
                child: enemyArray[3].build(),
              ),
            ),
            Opacity(
              opacity: enemyArray[4].opacity,
              child: new Transform.translate(
                offset: Offset(enemyArray[4].x, enemyArray[4].y),
                child: enemyArray[4].build(),
              ),
            ),
            Opacity(
              opacity: enemyArray[5].opacity,
              child: new Transform.translate(
                offset: Offset(enemyArray[5].x, enemyArray[5].y),
                child: enemyArray[5].build(),
              ),
            ),
            Opacity(
              opacity: enemyArray[6].opacity,
              child: new Transform.translate(
                offset: Offset(enemyArray[6].x, enemyArray[6].y),
                child: enemyArray[6].build(),
              ),
            ),
            Opacity(
              opacity: enemyArray[7].opacity,
              child: new Transform.translate(
                offset: Offset(enemyArray[7].x, enemyArray[7].y),
                child: enemyArray[7].build(),
              ),
            ),
            Opacity(
              opacity: enemyArray[8].opacity,
              child: new Transform.translate(
                offset: Offset(enemyArray[8].x, enemyArray[8].y),
                child: enemyArray[8].build(),
              ),
            ),
            Opacity(
              opacity: enemyArray[9].opacity,
              child: new Transform.translate(
                offset: Offset(enemyArray[9].x, enemyArray[9].y),
                child: enemyArray[9].build(),
              ),
            ),
          ],
        ));
  }
}
