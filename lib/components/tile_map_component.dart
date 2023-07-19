//import 'package:tiled/tiled.dart';
import 'package:dinojump03/consumibles/shield.dart';
import 'package:dinojump03/consumibles/win.dart';
import 'package:dinojump03/consumibles/life.dart';
import 'package:dinojump03/components/ground.dart';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class TileMapComponent extends PositionComponent {
  late TiledComponent tiledMap;

  List<Life> lifes = [];
  List<Shield> shield = [];
  List<Win> win = [];

  @override
  Future<void>? onLoad() async {
    tiledMap = await TiledComponent.load('map3.tmx', Vector2.all(32));
    add(tiledMap);

    final objGroup = tiledMap.tileMap.getLayer<ObjectGroup>('ground');
    position = Vector2(0, 0);
    for (var obj in objGroup!.objects) {
      add(Ground(
          size: Vector2(obj.width, /*obj.height*/ 20),
          position: Vector2(obj.x, obj.y)));
    }

    //addConsumibles();

    return super.onLoad();
  }

  void addConsumibles() {
    //** LIFES */
    final lifeGroup = tiledMap.tileMap.getLayer<ObjectGroup>('consumible_food');

    // removemos consumibles
    lifes.forEach((l) => l.removeFromParent());
    lifes.clear();

    for (var lifeObj in lifeGroup!.objects) {
      lifes.add(Life(position: Vector2(lifeObj.x, lifeObj.y)));
      add(lifes.last);
    }

    //** WIN */

    // removemos consumibles
    win.forEach((w) => w.removeFromParent());
    win.clear();

    final winGroup = tiledMap.tileMap.getLayer<ObjectGroup>('consumible_end');

    for (var winObj in winGroup!.objects) {
      win.add(Win(position: Vector2(winObj.x, winObj.y)));
      add(win.last);
    }

    //** Shield */

    // removemos consumibles
    shield.forEach((s) => s.removeFromParent());
    shield.clear();

    final shieldGroup =
        tiledMap.tileMap.getLayer<ObjectGroup>('consumible_invicible');

    for (var shieldObj in shieldGroup!.objects) {
      shield.add(Shield(position: Vector2(shieldObj.x, shieldObj.y)));
      add(shield.last);
    }
  }
}
