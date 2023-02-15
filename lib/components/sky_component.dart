import 'package:flame/components.dart';

class SkyComponent  extends SpriteComponent{

  @override
  Future<void>? onLoad() async{
    position = Vector2.all(0);
    sprite = await Sprite.load('background.jpg');
    size = sprite!.originalSize;
    return super.onLoad();
  }

}