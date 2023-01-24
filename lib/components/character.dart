import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum MovementType {
  walkingright,
  walkingleft,
  runright,
  runleft,
  idle,
  jump,
  jumpright,
  jumpleft,
}

class Character extends SpriteAnimationComponent
    with KeyboardHandler, CollisionCallbacks {
  int animationIndex = 0;
  
  MovementType movementType = MovementType.idle;

  double gravity = 9.8;
  Vector2 velocity = Vector2(0, 0);

  final double spriteSheetWidth = 680, spriteSheetHeight = 472;
  final double jumpForceUp = 400, jumpForceSide = 100, jumpForceXY = 20;

  bool inGround = false,
      jumpUp = false,
      right = true,
      collisionXRight = false,
      collisionXLeft = false;

  late SpriteAnimation deadAnimation,
      idleAnimation,
      jumpAnimation,
      runAnimation,
      walkAnimation,
      walkSlowAnimation;

  late RectangleHitbox body, foot;
}
