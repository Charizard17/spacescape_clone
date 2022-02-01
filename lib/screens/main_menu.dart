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
              child: Column(
                children: [
                  Text(
                    'Spacescape',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(shadows: [
                      Shadow(
                        blurRadius: 25.0,
                        color: Colors.yellow,
                        offset: Offset(0, 0),
                      ),
                    ], fontSize: 40),
                  ),
                  Text(
                    'Clone',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(shadows: [
                      Shadow(
                        blurRadius: 25.0,
                        color: Colors.yellow,
                        offset: Offset(0, 0),
                      ),
                    ], fontSize: 40),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 5 * 2,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.amber,
                ),
                child: Text(
                  'Play',
                  style: TextStyle(fontSize: 19, color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => GamePlay()),
                  );
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
                  'Settings',
                  style: TextStyle(fontSize: 19, color: Colors.black),
                ),
                onPressed: () {
                  // navigate to settings screen
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
