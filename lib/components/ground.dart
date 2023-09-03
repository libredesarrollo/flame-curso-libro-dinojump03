import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Ground extends PositionComponent {
  Ground({required size, required position})
      : super(size: size, position: position) {
    debugMode = true;
    // scale = Vector2.all(.5);
    add(RectangleHitbox()..collisionType = CollisionType.active);
  }
}
