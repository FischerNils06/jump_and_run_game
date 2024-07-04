// ignore_for_file: unnecessary_overrides

import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:jump_and_run_game/actors/enemys/enemy_jump.dart';


class Player extends SpriteComponent with HasGameRef {

  late final double jumpForce;
  final double gravity = 9.81;
  final double maxVelocity = 300;
  bool isOnTheGround = false;
  bool isJumping = false;
  bool isdoubletapped = false;
  Vector2 velocity = Vector2.zero();

    
  @override
  Future<void> onLoad() async {
    final screenSize = gameRef.size;
    sprite = await Sprite.load('character.png');
    size = Vector2(screenSize.x / 30, screenSize.x / 30);
    position = Vector2(screenSize.x/7, -screenSize.y / 5 - size.y);
    priority = 2;
    jumpForce = gameRef.size.y * 1; 

    return super.onLoad();
  }
  

  @override
  void update(double dt) {
    if (position.y + size.y >= -gameRef.size.y / 5) {
      isOnTheGround = true;
    } else {
      isOnTheGround = false;
    }
    addGravity(dt);

    if (isJumping) {
      jump(dt);
    }

    
  
    super.update(dt);
  }
  
  void jump(double dt) {
    if (isOnTheGround) {
      velocity.y = -jumpForce;
      position.y += velocity.y * dt;
      isOnTheGround = false;
    } 
    isJumping = false;
  }

  void addGravity(double dt) {
    final groundHeight = gameRef.size.y / 5;
    if (position.y + size.y < -groundHeight) {
      velocity.y += gravity;
      if (velocity.y > maxVelocity) {
        velocity.y = maxVelocity;
      }
      position.y += velocity.y * dt;
    } else {
      position.y = -groundHeight - size.y;
    }
  }

  

}