import 'package:dinojump03/main.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameOver extends StatefulWidget {
  final MyGame game;
  GameOver({Key? key, required this.game}) : super(key: key);

  @override
  State<GameOver> createState() => _GameOverState();
}

class _GameOverState extends State<GameOver> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        height: 200,
        width: 300,
        decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(children: [
          const Text(
            'Game Over',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          const SizedBox(
            height: 40,
          ),
          SizedBox(
            width: 200,
            height: 75,
            child: ElevatedButton(
              onPressed: () {
                print('hello');
                widget.game.colisionMeteors = 0;
                widget.game.player.position = Vector2.all(0);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: const Text(
                'Play Again',
                style: TextStyle(fontSize: 28, color: Colors.black),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
