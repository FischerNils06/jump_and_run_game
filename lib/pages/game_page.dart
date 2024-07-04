// ignore_for_file: unnecessary_import

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:jump_and_run_game/actors/player.dart';
import 'package:jump_and_run_game/actors/enemys/enemy_jump.dart';
import 'package:jump_and_run_game/stats/score.dart';


class GamePage extends World with HasGameRef, TapCallbacks, DoubleTapCallbacks {
  late SpriteComponent ground = SpriteComponent();
  
  get components => children;
  late List enemyList = [];
  bool spawnFirstEnemy = true;



  @override
  Future<void> onLoad() async {

    final screenSize = gameRef.size;

    ground
      ..sprite = await Sprite.load('ground.png')
      ..position = Vector2(0, - screenSize.y / 5)
      ..size = Vector2(screenSize.x, screenSize.y / 5)
      ..priority = 0;
    add(ground);

    final player = Player();
    add(player);

    final enemyJump = EnemyJump();
    add(enemyJump);

    final score = Score();
    add(score);



    return super.onLoad();
  }

  @override
  void update (double dt) {
    final enemyJumpList = components.whereType<EnemyJump>();
    final playerList = components.whereType<Player>();
    if (enemyJumpList.isNotEmpty) {
      final enemyJump = enemyJumpList.first;
      if (enemyJump.toSpawn) {
        add(EnemyJump());
        enemyJump.toSpawn = false;
      }
      if (enemyJump.toRemove) {
        remove(enemyJumpList.first);
        enemyJump.toRemove = false;
      }
      if (playerList.isNotEmpty) {
      final player = playerList.first;
      final playerPosition = player.position;
      for (final enemyJump in enemyJumpList) {
        final enemyJumpPosition = enemyJump.position;
        if (playerPosition.x < enemyJumpPosition.x + enemyJump.size.x &&
            playerPosition.x + player.size.x > enemyJumpPosition.x &&
            playerPosition.y < enemyJumpPosition.y + enemyJump.size.y &&
            playerPosition.y + player.size.y > enemyJumpPosition.y &&
            !enemyJump.collidedWithEnemy) {
          print('-1 live');
          enemyJump.collidedWithEnemy = true;
        }
      }

    }
    }  
   
    super.update(dt);
        

  }



  @override
  void onDoubleTapDown(DoubleTapDownEvent event) {
    final player = components.whereType<Player>().first;
    
    player.isJumping = false;
    if (player.size.x == 100) {
      player.size = Vector2(gameRef.size.x / 30, gameRef.size.x / 30);
      player.isdoubletapped = false;
    } else {
      player.size = Vector2(100, 100);
      player.isdoubletapped = true;
      player.position.y = (gameRef.size.x / 5);
    }
    //todo
  }


  @override
  void onTapDown(TapDownEvent event) {
    final player = components.whereType<Player>().first;
    if (!player.isdoubletapped) {
      player.isJumping = true;
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    final player = components.whereType<Player>().first;
    player.isJumping = false;
  }




}
