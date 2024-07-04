import 'package:flame/components.dart';
import 'package:jump_and_run_game/actors/player.dart';
import 'package:jump_and_run_game/pages/game_page.dart';
import 'dart:math';

class EnemyJump extends SpriteComponent with HasGameRef {

  late final List enemyWidths;
  late final List enemyHights;
  bool toRemove = false;
  bool toSpawn = false;
  bool spawned = false;
  bool collidedWithEnemy = false;


  @override
  Future<void> onLoad() async {
    final screenSize = gameRef.size;
    enemyWidths = [screenSize.y/8, screenSize.y/10, screenSize.y/12, screenSize.y/15, screenSize.y/20];
    enemyHights = [screenSize.y, screenSize.y/4, screenSize.y/4.5, screenSize.y/5];
    double enemyWidth = enemyWidths[Random().nextInt(enemyWidths.length)];
    double enemyHight = enemyHights[Random().nextInt(enemyHights.length)];
    sprite = await Sprite.load('enemy_jump.png');
    size = Vector2(enemyWidth, enemyHight);
    position = Vector2(screenSize.x, -screenSize.y / 5 - size.y);
    priority = 1;

    return super.onLoad();
  }

  @override
  void update (double dt) {
    position.x -= 2;

    if (position.x <= -size.x) {
        toRemove = true;
        if (!spawned) {
            toSpawn = true;
          }
    }

    int randomDistance = Random().nextInt(100)+ 1;
    
    if (position.x <= gameRef.size.x / 1.5 && randomDistance >= 99 && !spawned) {
        toSpawn = true;
        spawned = true;
    }
    

  }
}