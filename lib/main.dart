
import 'package:flutter/material.dart';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/collisions.dart';

import 'package:dinojump03/components/meteor_component.dart';
import 'package:dinojump03/components/player_component.dart';
import 'package:dinojump03/components/sky_component.dart';
import 'package:dinojump03/components/tile_map_component.dart';
import 'package:dinojump03/ovelays/game_over.dart';
import 'package:dinojump03/ovelays/stadistics.dart';

class MyGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  double elapsedTime = 0.0;
  int colisionMeteors = 0;
  late PlayerComponent player;
  late TileMapComponent background;

  @override
  Future<void>? onLoad() {
    background = TileMapComponent();
    add(SkyComponent());
    add(background);

    background.loaded.then(
      (value) {
        player = PlayerComponent(mapSize: background.tiledMap.size, game: this);
        add(player);

        camera.followComponent(player,
            worldBounds: Rect.fromLTRB(
                0, 0, background.tiledMap.size.x, background.tiledMap.size.y));
      },
    );

    add(ScreenHitbox());

    //return super.onLoad();
  }

  @override
  void update(double dt) {
    if (elapsedTime > 1.0) {
      add(MeteorComponent(cameraPosition: camera.position));
      elapsedTime = 0.0;
    }

    elapsedTime += dt;
    super.update(dt);
  }

  @override
  Color backgroundColor() {
    super.backgroundColor();
    return Colors.purple;
  }

  void addConsumibles() {
    background.addConsumibles();
  }

}

void main() {
  runApp(GameWidget(
    game: MyGame(),
    overlayBuilderMap: {
      'Statistics': (context, MyGame game) {
        return Statistics(
          game: game,
        );
      },
      'GameOver': (context, MyGame game) {
        return GameOver(
          game: game,
        );
      }
    },
    initialActiveOverlays: const ['Statistics'],
  ));
}
