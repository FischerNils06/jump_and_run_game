// ignore_for_file: unnecessary_import

import 'package:flame/components.dart';
import 'package:flame/game.dart';

class Lives extends TextComponent with HasGameRef {
  int lives = 3;
  bool gameOver = false;
  

  @override
  Future<void> onLoad() async {
    final screenSize = gameRef.size;
    text = '❤️ x$lives';
    anchor = Anchor.center;
    position= Vector2(screenSize.x/5,-screenSize.y + screenSize.y / 10);
    priority = 3;
    return super.onLoad();
  }


  void removeLive() {
    if (lives > 1) {
      lives -= 1;
      text = '❤️ x$lives';
    } else {
      gameOver = true;
    }

    

  }

  
}