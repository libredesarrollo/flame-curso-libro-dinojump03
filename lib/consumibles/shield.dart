import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Shield extends SpriteComponent {
  Shield({required position}) : super(position: position) {
    debugMode = true;
    add(RectangleHitbox()..collisionType = CollisionType.active);
  }

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load('shield.png');
    size = Vector2.all(40);
    return super.onLoad();
  }
}


