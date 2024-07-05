import 'dart:math';

import 'package:flame/components.dart';
import 'package:jump_and_run_game/actors/player.dart';
import 'package:jump_and_run_game/actors/enemies/enemy_jump.dart';
import 'package:jump_and_run_game/items/item.dart';
import 'package:jump_and_run_game/stats/lives.dart';
import 'package:jump_and_run_game/stats/score.dart';
import 'package:jump_and_run_game/pages/game_over_page.dart';


class GamePage extends World with HasGameRef {
  late SpriteComponent ground = SpriteComponent();
  
  get components => children;
  bool isSwipedDown = false;
  int swipedDown = 0;
  int itemDistance = 0;
  bool gameFinished = false;



  @override
  Future<void> onLoad() async {

    final screenSize = gameRef.size;
    gameFinished = false;

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
    final livesList = components.whereType<Lives>();
    final scoreList = components.whereType<Score>();
    final gameOverPageList = components.whereType<GameOverPage>();

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
          if (livesList.isNotEmpty) {
            final lives = livesList.first;
            lives.removeLive();
          }
          enemyJump.collidedWithEnemy = true;
        }
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
            if (scoreList.isNotEmpty) {
              final score = scoreList.first;
                score.setScore();
            }
          } else {
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
    if (livesList.isNotEmpty) {
      final lives = livesList.first;
      if (lives.gameOver) {
        if (!gameFinished) {
          gameOver();
        }

      }
    }

    if (gameOverPageList.isNotEmpty) {
      final gameOverPage = gameOverPageList.first;
      if (gameOverPage.toRestart) {
        gameOverPage.toRestart = false;
        remove(gameOverPage);
        onLoad();
      }
    }

    
   
    super.update(dt);
        

  }



  void swipeDown () {
    final playerList = components.whereType<Player>();
    if (playerList.isNotEmpty) {
      final player = playerList.first;
      isSwipedDown = true;
      player.isJumping = false;
      player.size = Vector2(gameRef.size.x / 30, gameRef.size.x / 36);
      player.changeGravity(10);
    }
    
  }

  void swipeUp() {
    final playerList = components.whereType<Player>();
    if (playerList.isNotEmpty) {
      final player = playerList.first;
      if (!isSwipedDown) {
      player.isJumping = true;
      } else {
        isSwipedDown = false;
      }
    }
    
  }
  
  void gameOver () {
    gameFinished = true;
    
    final livesList = components.whereType<Lives>();
    if (livesList.isNotEmpty) {
      final lives = livesList.first;
      remove(lives);
    }
    final scoreList = components.whereType<Score>();
    if (scoreList.isNotEmpty) {
      final score = scoreList.first;
      remove(score);
    }
    final playerList = components.whereType<Player>();
    if (playerList.isNotEmpty) {
      final player = playerList.first;
      remove(player);
    }
    final enemyJumpList = components.whereType<EnemyJump>();
    if (enemyJumpList.isNotEmpty) {
      for (final enemyJump in enemyJumpList) {
        remove(enemyJump);
      }
    }
    final itemList = components.whereType<Item>();
    if (itemList.isNotEmpty) {
      for (final item in itemList) {
        remove(item);
      }
    }

    final gameOverPage = GameOverPage();
    add(gameOverPage);
    
  }

}
