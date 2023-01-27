import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Win extends SpriteComponent {
  Win({required position}) : super(position: position) {
    debugMode = true;
    add(RectangleHitbox()..collisionType = CollisionType.active);
  }

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load('star.png');
    size = Vector2.all(40);
    return super.onLoad();
  }
}


