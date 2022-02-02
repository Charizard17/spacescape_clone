import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:spacescape_clone/widgets/overlays/pause_menu.dart';

import '../game/game.dart';
import '../widgets/overlays/pause_button.dart';

SpacescapeGame _spacescapeGame = SpacescapeGame();

class GamePlay extends StatelessWidget {
  const GamePlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: SafeArea(
        child: Scaffold(
          body: WillPopScope(
            onWillPop: () async => false,
            child: GameWidget(
              game: _spacescapeGame,
              initialActiveOverlays: [PauseButton.ID],
              overlayBuilderMap: {
                PauseButton.ID:
                    (BuildContext context, SpacescapeGame gameRef) =>
                        PauseButton(gameRef: gameRef),
                PauseMenu.ID: (BuildContext context, SpacescapeGame gameRef) =>
                    PauseMenu(gameRef: gameRef),
              },
            ),
          ),
        ),
      ),
    );
  }
}
