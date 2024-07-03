import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:jump_and_run_game/main_game.dart';
import 'package:flame/flame.dart';



void main() {
WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  MainGame game = MainGame();
  runApp(GameWidget(game: game));
}
