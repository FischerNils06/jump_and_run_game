// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_import, use_key_in_widget_constructors

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GameOverPage extends SpriteComponent with HasGameRef, TapCallbacks {

  bool toRestart = false;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('game_over.png');
    size = Vector2(gameRef.size.x / 4, gameRef.size.x / 8);
    position = Vector2((gameRef.size.x / 2) - (size.x /2), (-gameRef.size.y / 2) - (size.y / 2));
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    toRestart = true;
  }
}