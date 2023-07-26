import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Ground extends PositionComponent {
  Ground({required size, required position})
      : super(size: size, position: position) {
    debugMode = true;
    add(RectangleHitbox()..collisionType = CollisionType.active);
  }
}
