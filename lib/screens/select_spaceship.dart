import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:spacescape_clone/screens/main_menu.dart';

import '../models/spaceship_details.dart';
import './game_play.dart';

class SelectSpaceship extends StatelessWidget {
  const SelectSpaceship({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Text(
                'Select',
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
              height: MediaQuery.of(context).size.height * 0.4,
              child: CarouselSlider.builder(
                itemCount: Spaceship.spaceships.length,
                slideBuilder: (int index) {
                  final spaceship =
                      Spaceship.spaceships.entries.elementAt(index).value;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(spaceship.assetPath),
                      Text(
                        '${spaceship.name}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Speed: ${spaceship.speed}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Level: ${spaceship.level}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Cost: ${spaceship.cost}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 5),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 5 * 2,
                        child: ElevatedButton(
                          child: Text(
                            'Select',
                            style: TextStyle(fontSize: 19, color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.amber,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 5 * 2,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.amber,
                ),
                child: Text(
                  'Start',
                  style: TextStyle(fontSize: 19, color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => GamePlay(),
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
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => MainMenu(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
