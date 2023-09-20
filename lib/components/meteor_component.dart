import 'dart:math';

import 'package:flame/experimental.dart';

import 'package:flame/collisions.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flame/components.dart';

import 'package:dinojump03/utils/create_animation_by_limit.dart';

class MeteorComponent extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameReference {
  Vector2 cameraPosition;

  MeteorComponent({required this.cameraPosition}) : super() {
    debugMode = true;
    // scale = Vector2.all(0.5);
  }

  static const int circleSpeed = 500;
  static const double circleWidth = 100.0;
  static const double circleHeight = 200.0;

  Random random = Random();

  late double screenWidth;
  late double screenHeight;

  final ShapeHitbox hitbox = CircleHitbox();

  final double spriteSheetWidth = 461;
  final double spriteSheetHeight = 996;

  @override
  Future<void>? onLoad() async {
    // screenWidth = MediaQueryData.fromWindow(window).size.width;
    // screenHeight = MediaQueryData.fromWindow(window).size.height;

    screenWidth = game.size.x;
    screenHeight = game.size.y;

    position = Vector2(random.nextDouble() * screenWidth + cameraPosition.x,
        cameraPosition.y - circleHeight);
    size = Vector2(circleWidth, circleHeight);

    hitbox.paint.color = BasicPalette.green.color;
    hitbox.renderShape = false;
    hitbox.position = Vector2(0, 50);
    hitbox.collisionType = CollisionType.passive;

    final spriteImage = await Flame.images.load('meteor.png');
    final spriteSheet = SpriteSheet(
        image: spriteImage,
        srcSize: Vector2(spriteSheetWidth, spriteSheetHeight));

    // init animation
    animation = spriteSheet.createAnimationByLimit(
        xInit: 0, yInit: 0, step: 3, sizeX: 3, stepTime: .08);

    add(hitbox);
    // scale = Vector2.all(.5);

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
