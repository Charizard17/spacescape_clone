import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/game.dart';

SpacescapeGame _spacescapeGame = SpacescapeGame();

class GamePlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GameWidget(game: _spacescapeGame),
    );
  }
}
