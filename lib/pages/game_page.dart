// ignore_for_file: unnecessary_import

import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:jump_and_run_game/actors/player.dart';
import 'package:jump_and_run_game/actors/enemys/enemy_jump.dart';
import 'package:jump_and_run_game/items/item.dart';
import 'package:jump_and_run_game/stats/lives.dart';
import 'package:jump_and_run_game/stats/score.dart';


class GamePage extends World with HasGameRef {
  late SpriteComponent ground = SpriteComponent();
  
  get components => children;
  late List enemyList = [];
  bool spawnFirstEnemy = true;
  bool isSwipedDown = false;
  int swipedDown = 0;
  int itemDistance = 0;
  bool gameFinished = false;



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

    final lives = Lives();
    add(lives);




    return super.onLoad();
  }

  @override
  void update (double dt) {
    final enemyJumpList = components.whereType<EnemyJump>();
    final playerList = components.whereType<Player>();
    final itemList = components.whereType<Item>();
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
      player.score = enemyJump.score;
      final playerPosition = player.position;
      for (final enemyJump in enemyJumpList) {
        final enemyJumpPosition = enemyJump.position;
        if (playerPosition.x < enemyJumpPosition.x + enemyJump.size.x &&
            playerPosition.x + player.size.x > enemyJumpPosition.x &&
            playerPosition.y < enemyJumpPosition.y + enemyJump.size.y &&
            playerPosition.y + player.size.y > enemyJumpPosition.y &&
            !enemyJump.collidedWithEnemy) {
          final livesList = components.whereType<Lives>();
          if (livesList.isNotEmpty) {
            final lives = livesList.first;
            lives.removeLive();
          }
          enemyJump.collidedWithEnemy = true;
        }
        final scoreList = components.whereType<Score>();
        if (scoreList.isNotEmpty) {
          final score = scoreList.first;
          enemyJump.score = score.score;
        }
      }
      for (final item in itemList) {
        final itemPosition = item.position;
        if (playerPosition.x < itemPosition.x + item.size.x &&
            playerPosition.x + player.size.x > itemPosition.x &&
            playerPosition.y < itemPosition.y + item.size.y &&
            playerPosition.y + player.size.y > itemPosition.y) {
          final itemType = item.getSprite();
          if (itemType == 'star') {
            final scoreList = components.whereType<Score>();
            if (scoreList.isNotEmpty) {
              final score = scoreList.first;
                score.setScore();
            }
          } else {
            final livesList = components.whereType<Lives>();
            if (livesList.isNotEmpty) {
              final lives = livesList.first;
              lives.lives += 1;
              lives.text = '❤️ x${lives.lives}';
            }
          }
          remove(item);
        }
      }
      if (isSwipedDown) {
        if (swipedDown <= 100) {
          swipedDown += 1;
        } else {
          isSwipedDown = false;
        }
        
      } else {
        swipedDown = 0;
        player.changeGravity(1);
        player.size = Vector2(gameRef.size.x / 30, gameRef.size.x / 30);
      }
      
      if (itemDistance == 0) {
          int randomDistance = Random().nextInt(500)+ 1;
          if (randomDistance == 99) {
            add(Item());
            itemDistance += 1;
          }
      } else {
        itemDistance += 1;
        if (itemDistance >= 100) {
          itemDistance = 0;
        }
      }

    }
    }
    final livesList = components.whereType<Lives>();
    if (livesList.isNotEmpty) {
      final lives = livesList.first;
      if (lives.gameOver) {
        if (gameFinished) {
          print('Game Over');
        }

      }
    }
   
    super.update(dt);
        

  }



  void swipeDown () {
    final player = components.whereType<Player>().first;
    isSwipedDown = true;
    player.isJumping = false;
    player.size = Vector2(gameRef.size.x / 30, gameRef.size.x / 36);
    player.changeGravity(10);
  }

  void swipeUp() {
    final player = components.whereType<Player>().first;
    if (!isSwipedDown) {
      player.isJumping = true;
    } else {
      isSwipedDown = false;
    }
  }
  

}
