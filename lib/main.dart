import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import './game/game.dart';

void main() {
  final SpacescapeGame game = SpacescapeGame();

  runApp(GameWidget(game: game));
}