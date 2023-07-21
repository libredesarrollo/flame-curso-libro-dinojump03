import 'package:flutter/material.dart';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

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

  final world = World();

  late final CameraComponent cameraComponent;

  @override
  void onLoad() {
    background = TileMapComponent();
    add(world);

    world.add(SkyComponent());
    world.add(background);

    background.loaded.then(
      (value) {
        player = PlayerComponent(mapSize: background.tiledMap.size, game: this);
        //add(player);

        cameraComponent = CameraComponent(world: world);
        cameraComponent.follow(player);
        cameraComponent.setBounds(Rectangle.fromLTRB(
            0, 0, background.tiledMap.size.x, background.tiledMap.size.y));
        // cameraComponent.viewfinder.anchor = Anchor.bottomLeft;
        cameraComponent.viewfinder.anchor = const Anchor(0.1, 0.9);
        add(cameraComponent);

        cameraComponent.world.add(player);

        // camera.followComponent(player,
        //     worldBounds: Rect.fromLTRB(
        //         0, 0, background.tiledMap.size.x, background.tiledMap.size.y));
      },
    );

    add(ScreenHitbox());
  }

  @override
  void update(double dt) {
    if (elapsedTime > 1.0) {
      Vector2 cp = cameraComponent.viewfinder.position;

      cp.y = cameraComponent.viewfinder.position.y -
          cameraComponent.viewport.size.y;
      world.add(MeteorComponent(cameraPosition: cp));
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
