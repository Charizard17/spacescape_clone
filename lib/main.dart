import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:spacescape_clone/models/player_data.dart';

import './screens/main_menu.dart';
import './game/game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();

  runApp(
    ChangeNotifierProvider(
      create: (context) => PlayerData.fromMap(PlayerData.defaultData),
      child: MaterialApp(
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(
          fontFamily: 'BungeeInline',
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
        ),
        home: const MainMenu(),
      ),
    ),
  );
}
