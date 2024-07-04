import 'dart:math';

import 'package:flame/components.dart';

class Item extends SpriteComponent with HasGameRef {

  bool toRemove = false;
  final spriteList = ['star.png', 'heart.png'];
  final randomSprite = Random().nextInt(2);

  @override
  Future<void> onLoad() async {
    final screenSize = gameRef.size;

    sprite = await Sprite.load(spriteList[randomSprite]);
    size = Vector2(screenSize.x / 30, screenSize.x / 30);
    position = Vector2(screenSize.x, -screenSize.y / 5 - size.y);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.x -= 100 * dt;

    if (position.x <= -size.x) {
        toRemove = true;
    }
    super.update(dt);
  }

  String getSprite() {
    if (randomSprite == 0) {
      return 'star';
    } else {
      return 'heart';
    }
  }

}