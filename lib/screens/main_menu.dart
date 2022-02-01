import 'package:flutter/material.dart';
import 'package:spacescape_clone/screens/game_play.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Text('Spacescape Clone'),
            ),
            ElevatedButton(
              child: Text('Play'),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => GamePlay()),
                );
              },
            ),
            ElevatedButton(
              child: Text('Settings'),
              onPressed: () {
                // navigate to settings screen
              },
            ),
          ],
        ),
      ),
    );
  }
}
