import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flame/collisions.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flame/components.dart';

import 'package:dinojump03/utils/create_animation_by_limit.dart';

class MeteorComponent extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef {
  Vector2 cameraPosition;

  MeteorComponent({required this.cameraPosition}) : super() {
    debugMode = true;
    // scale = Vector2.all(0.5);
  }

  static const int circleSpeed = 500;
  static const double circleWidth = 100.0, circleHeight = 100.0;

  Random random = Random();

  late double screenWidth, screenHeight;

  final ShapeHitbox hitbox = CircleHitbox();

  final double spriteSheetWidth = 79, spriteSheetHeight = 100;

  @override
  Future<void>? onLoad() async {
    // screenWidth = MediaQueryData.fromWindow(window).size.width;
    // screenHeight = MediaQueryData.fromWindow(window).size.height;

    screenWidth = gameRef.size.x;
    screenHeight = gameRef.size.y;

    position = Vector2(random.nextDouble() * screenWidth + cameraPosition.x,
        cameraPosition.y - circleHeight);
    size = Vector2(circleWidth, circleHeight);

    hitbox.paint.color = BasicPalette.green.color;
    hitbox.renderShape = false;
    hitbox.collisionType = CollisionType.passive;

    final spriteImage = await Flame.images.load('meteor.png');
    final spriteSheet = SpriteSheet(
        image: spriteImage,
        srcSize: Vector2(spriteSheetWidth, spriteSheetHeight));

    // init animation
    animation = spriteSheet.createAnimationByLimit(
        xInit: 0, yInit: 0, step: 4, sizeX: 4, stepTime: .08);

    add(hitbox);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.y += circleSpeed * dt;

    if (position.y > cameraPosition.y + screenHeight) {
      removeFromParent();
    }

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if (other is ScreenHitbox) {}

    super.onCollision(points, other);
  }
}
