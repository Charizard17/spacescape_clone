import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 2)
class Settings extends ChangeNotifier with HiveObjectMixin {
  static const String SETTINGS_BOX = 'SettingsBox';
  static const String SETTINGS_KEY = 'Settings';

  @HiveField(0)
  bool _soundEffects = false;
  bool get soundEffects => _soundEffects;
  set soundEffects(bool value) {
    _soundEffects = value;
    notifyListeners();
    save();
  }

  @HiveField(1)
  bool _backgroundMusic = false;
  bool get backgroundMusic => _backgroundMusic;
  set backgroundMusic(bool value) {
    _backgroundMusic = value;
    notifyListeners();
    save();
  }

  Settings({
    bool soundEffects = false,
    bool backgroundMusic = false,
  })  : this._soundEffects = soundEffects,
        this._backgroundMusic = backgroundMusic;
}
