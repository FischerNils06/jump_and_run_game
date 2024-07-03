import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:jump_and_run_game/actors/player.dart';


class GamePage extends World with HasGameRef, TapCallbacks, DoubleTapCallbacks {

  late SpriteComponent ground = SpriteComponent();
  
  get components => children;


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


    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    final player = components.whereType<Player>().first;
    player.isJumping = true;
  }

  @override
  void onTapUp(TapUpEvent event) {
    final player = components.whereType<Player>().first;
    player.isJumping = false;
  }

  @override
  void onDoubleTapDown(DoubleTapDownEvent event) {
    final player = components.whereType<Player>().first;
    if (player.size.x == 100) {
      player.size = Vector2(gameRef.size.x / 10, gameRef.size.x / 10);
    } else {
      player.size = Vector2(100, 100);
    }
    // todo: implement
  }


}
