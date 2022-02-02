import 'package:flutter/material.dart';

import '../../screens/main_menu.dart';
import '../../game/game.dart';
import './pause_button.dart';

class PauseMenu extends StatelessWidget {
  static const String ID = 'PauseMenu';
  final SpacescapeGame gameRef;

  const PauseMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Text(
              'Paused',
              style: TextStyle(
                fontSize: 40,
                color: Colors.black,
                shadows: [
                  Shadow(
                    blurRadius: 20.0,
                    color: Colors.amber,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 5 * 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.amber,
              ),
              child: Text(
                'Resume',
                style: TextStyle(fontSize: 19, color: Colors.black),
              ),
              onPressed: () {
                gameRef.resumeEngine();
                gameRef.overlays.remove(PauseMenu.ID);
                gameRef.overlays.add(PauseButton.ID);
              },
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width / 5 * 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.amber,
              ),
              child: Text(
                'Reset',
                style: TextStyle(fontSize: 19, color: Colors.black),
              ),
              onPressed: () {
                gameRef.overlays.remove(PauseMenu.ID);
                gameRef.overlays.add(PauseButton.ID);
                gameRef.reset();
                gameRef.resumeEngine();
              },
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width / 5 * 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.amber,
              ),
              child: Text(
                'Quit Game',
                style: TextStyle(fontSize: 19, color: Colors.black),
              ),
              onPressed: () {
                gameRef.overlays.remove(PauseMenu.ID);
                gameRef.reset();

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const MainMenu(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
