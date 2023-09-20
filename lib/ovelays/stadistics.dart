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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Count collision ${widget.game.collisionMeteors}',
                style: const TextStyle(color: Colors.white, fontSize: 30),
              ),
              const Expanded(
                  child: SizedBox(
                height: 10,
              )),
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.game.paused = !widget.game.paused;
                  });
                },
                child: Icon(
                  widget.game.paused ? Icons.play_arrow : Icons.pause,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.game.player.reset();
                  });
                },
                child: const Icon(
                  Icons.replay,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Icon(
                widget.game.collisionMeteors >= 3
                    ? Icons.favorite_border
                    : Icons.favorite,
                color: Colors.red,
              ),
              Icon(
                widget.game.collisionMeteors >= 2
                    ? Icons.favorite_border
                    : Icons.favorite,
                color: Colors.red,
              ),
              Icon(
                widget.game.collisionMeteors >= 1
                    ? Icons.favorite_border
                    : Icons.favorite,
                color: Colors.red,
              ),
            ],
          )
        ],
      ),
    );
  }
}
