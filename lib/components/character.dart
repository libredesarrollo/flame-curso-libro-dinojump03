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

  double gravity = 15;
  Vector2 velocity = Vector2(0, 0);

  final double spriteSheetWidth = 680;
  final double spriteSheetHeight = 472;
  final double jumpForceUp = 600;
  final double jumpForceSide = 100;
  final double jumpForceXY = 20;

  bool inGround = false;
  bool jumpUp = false;
  bool right = true;
  bool collisionXRight = false;
  bool collisionXLeft = false;

  late SpriteAnimation deadAnimation;
  late SpriteAnimation idleAnimation;
  late SpriteAnimation jumpAnimation;
  late SpriteAnimation runAnimation;
  late SpriteAnimation walkAnimation;
  late SpriteAnimation walkSlowAnimation;

  late RectangleHitbox body /*, foot*/;
}
