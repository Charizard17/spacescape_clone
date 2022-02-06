import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:spacescape_clone/models/player_data.dart';
import 'package:spacescape_clone/models/settings.dart';
import 'package:spacescape_clone/models/spaceship_details.dart';

import './screens/main_menu.dart';
import './game/game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();

  await initHive();

  runApp(
    MultiProvider(
      providers: [
        FutureProvider<PlayerData>(
          create: (BuildContext context) => getPlayerData(),
          initialData: PlayerData.fromMap(PlayerData.defaultData),
        ),
        FutureProvider<Settings>(
          create: (BuildContext context) => getSettings(),
          initialData: Settings(soundEffects: false, backgroundMusic: false),
        ),
      ],
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<PlayerData>.value(
              value: Provider.of<PlayerData>(context),
            ),
            ChangeNotifierProvider<Settings>.value(
              value: Provider.of<Settings>(context),
            ),
          ],
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
  Hive.registerAdapter(SettingsAdapter());
}

Future<PlayerData> getPlayerData() async {
  final box = await Hive.openBox<PlayerData>(PlayerData.PLAYER_DATA_BOX);
  final playerData = box.get(PlayerData.PLAYER_DATA_KEY);
  if (playerData == null) {
    box.put(
        PlayerData.PLAYER_DATA_KEY, PlayerData.fromMap(PlayerData.defaultData));
  }
  return box.get(PlayerData.PLAYER_DATA_KEY)!;
}

Future<Settings> getSettings() async {
  final box = await Hive.openBox<Settings>(Settings.SETTINGS_BOX);
  final settings = box.get(Settings.SETTINGS_KEY);
  if (settings == null) {
    box.put(Settings.SETTINGS_KEY,
        Settings(soundEffects: true, backgroundMusic: true));
  }
  return box.get(Settings.SETTINGS_KEY)!;
}
