import 'package:flame/components.dart';

class Score extends TextComponent with HasGameRef {
  int score = 0;
  int highscore = 0;
  

  @override
  Future<void> onLoad() async {
    final screenSize = gameRef.size;
    text = 'Score: $score';
    anchor = Anchor.center;
    position= Vector2(screenSize.x - screenSize.x/5,-screenSize.y + screenSize.y / 10);
    priority = 3;
    return super.onLoad();
  }

  
}