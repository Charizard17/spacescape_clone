import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:spacescape_clone/models/player_data.dart';
import 'package:spacescape_clone/models/spaceship_details.dart';

import './screens/main_menu.dart';
import './game/game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();

  runApp(
    FutureProvider<PlayerData>(
      create: (BuildContext context) => getPlayerData(),
      initialData: PlayerData.fromMap(PlayerData.defaultData),
      builder: (context, child) {
        return ChangeNotifierProvider<PlayerData>.value(
          value: Provider.of<PlayerData>(context),
          child: child,
        );
      },
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

Future<void> initHive() async {
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  Hive.registerAdapter(PlayerDataAdapter());
  Hive.registerAdapter(SpaceshipTypeAdapter());
}

Future<PlayerData> getPlayerData() async {
  await initHive();

  final box = await Hive.openBox<PlayerData>('PlayerDataBox');
  final playerData = box.get('PlayerData');
  if (playerData == null) {
    box.put('PlayerData', PlayerData.fromMap(PlayerData.defaultData));
  }
  return box.get('PlayerData')!;
}
