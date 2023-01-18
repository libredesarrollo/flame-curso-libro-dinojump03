import 'package:dinojump03/main.dart';
import 'package:flutter/material.dart';

class Statistics extends StatefulWidget {
  final MyGame game;
  Statistics({Key? key, required this.game}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Count colision ${widget.game.colisionMeteors}',
        style: const TextStyle(color: Colors.white, fontSize: 30),
      ),
    );
  }
}
