import 'package:dinojump03/components/player_component.dart';
import 'package:dinojump03/components/tile_map_component.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  double elapsedTime = 0.0;

  @override
  Future<void>? onLoad() {
    var background = TileMapComponent();
    add(background);

    background.loaded.then(

      (value) {
        var player = PlayerComponent(mapSize:  background.tiledMap.size);
        add(player);

        //camera.followComponent(player, worldBounds: Rect.fromLTRB(0, 0, background.size.x, background.size.y));

      },
    );

    add(ScreenHitbox());

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  Color backgroundColor() {
    super.backgroundColor();
    return Colors.purple;
  }
}

void main() {
  runApp(GameWidget(game: MyGame()));
}
