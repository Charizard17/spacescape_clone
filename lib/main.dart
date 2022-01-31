import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import './game/game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  final SpacescapeGame game = SpacescapeGame();

  runApp(
    Padding(
      padding: const EdgeInsets.only(top: 40),
      child: GameWidget(game: game),
    ),
  );
}
