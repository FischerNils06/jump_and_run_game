// ignore_for_file: unnecessary_overrides

import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:jump_and_run_game/actors/enemys/enemy_jump.dart';


class Player extends SpriteComponent with HasGameRef {

  late double jumpForce;
  late final double initialJumpForce;
  double gravity = 9.81;
  double initialgravity = 9.81;
  double maxVelocity = 300;
  bool isOnTheGround = false;
  bool isJumping = false;
  bool isdoubletapped = false;
  bool isScoreUpdated = false;
  Vector2 velocity = Vector2.zero();
  int score = 0;
  int currentScore = 0;
  int gravityValue = 1;

    
  @override
  Future<void> onLoad() async {
    final screenSize = gameRef.size;
    sprite = await Sprite.load('character.png');
    size = Vector2(screenSize.x / 30, screenSize.x / 30);
    position = Vector2(screenSize.x/7, -screenSize.y / 5 - size.y);
    priority = 2;
    initialJumpForce = gameRef.size.y;
    jumpForce = initialJumpForce; 

    return super.onLoad();
  }
  

  @override
  void update(double dt) {
    if (position.y + size.y >= -gameRef.size.y / 5) {
      isOnTheGround = true;
    } else {
      isOnTheGround = false;
    }
    
    jumpForce = gameRef.size.y + (score * gameRef.size.y / 100);

    if (currentScore != score) {
      isScoreUpdated = true;
    }

    currentScore = score;

    gravity = initialgravity * ((jumpForce * jumpForce) / (initialJumpForce * initialJumpForce)) * gravityValue;
    
    print(gravity);
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

  void changeGravity(int value) {
      gravityValue = value;
  }

  

}