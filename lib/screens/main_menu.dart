import 'package:flutter/material.dart';

import './select_spaceship.dart';

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
                  Text(
                    'Clone',
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
                    MaterialPageRoute(
                      builder: (context) => SelectSpaceship(),
                    ),
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
