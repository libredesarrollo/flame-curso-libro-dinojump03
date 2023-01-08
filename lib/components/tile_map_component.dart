import 'package:dinojump03/components/ground.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
//import 'package:tiled/tiled.dart';

class TileMapComponent extends PositionComponent {
  late TiledComponent tiledMap;

  @override
  Future<void>? onLoad() async{
    
    tiledMap =  await TiledComponent.load('map.tmx', Vector2.all(32));
    add(tiledMap);

    final objGrounp = tiledMap.tileMap.getLayer<ObjectGroup>('ground');

    for (var obj in objGrounp!.objects) {
      print(obj.width.toString()+' '+obj.height.toString());
      add(Ground(size: Vector2(obj.width, obj.height), position: Vector2(obj.x, obj.y) ));
    }

    return super.onLoad();
  }
}
