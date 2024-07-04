import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:jump_and_run_game/pages/game_page.dart';
import 'package:flame/extensions.dart';

class MainGame extends FlameGame with VerticalDragDetector {
  
  late final CameraComponent cameraComp;
  final gamePage = GamePage();
  


  @override
  Color backgroundColor() => Color(0xFF44aaff);
  
  @override
  Future<void> onLoad() async {
    cameraComp = CameraComponent.withFixedResolution(world: gamePage, width: size.x, height: size.y);
    cameraComp.viewfinder.anchor = Anchor.bottomLeft;
    addAll([cameraComp, gamePage]);
    return super.onLoad();
  }

  @override
  void onVerticalDragUpdate(DragUpdateInfo info) {
    final delta = info.delta.global.y;

    if (delta > 0) {
      gamePage.swipeDown();
    } else {
      gamePage.swipeUp();
    }
    
  }


  
}