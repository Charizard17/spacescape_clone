import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacescape_clone/models/settings.dart';

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({Key? key}) : super(key: key);

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
                    'Settings',
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Selector<Settings, bool>(
                    selector: (context, settings) => settings.soundEffects,
                    builder: (context, value, child) {
                      return SwitchListTile(
                        title: Text('Sound Effects'),
                        activeColor: Colors.amber,
                        activeTrackColor: Colors.amber.withAlpha(100),
                        value: value,
                        onChanged: (newValue) {
                          Provider.of<Settings>(context, listen: false)
                              .soundEffects = newValue;
                        },
                      );
                    },
                  ),
                  SizedBox(height: 5),
                  Selector<Settings, bool>(
                    selector: (context, settings) => settings.backgroundMusic,
                    builder: (context, value, child) {
                      return SwitchListTile(
                        title: Text('Background Music'),
                        activeColor: Colors.amber,
                        activeTrackColor: Colors.amber.withAlpha(100),
                        value: value,
                        onChanged: (newValue) {
                          Provider.of<Settings>(context, listen: false)
                              .backgroundMusic = newValue;
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
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
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
