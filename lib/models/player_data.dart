import 'package:flutter/material.dart';

import './spaceship_details.dart';

class PlayerData extends ChangeNotifier {
  final SpaceshipType spaceshipType;
  final List<SpaceshipType> ownedSpaceships;
  final int highScore;
  final int money;

  PlayerData({
    required this.spaceshipType,
    required this.ownedSpaceships,
    required this.highScore,
    required this.money,
  });

  PlayerData.fromMap(Map<String, dynamic> map)
      : this.spaceshipType = map['currentSpaceshipType'],
        this.ownedSpaceships = map['ownedSpaceshipTypes']
            .map((e) => e as SpaceshipType)
            .cast<SpaceshipType>()
            .toList(),
        this.highScore = map['highScore'],
        this.money = map['money'];

  static Map<String, dynamic> defaultData = {
    'currentSpaceshipType': SpaceshipType.Phoenix,
    'ownedSpaceshipTypes': [],
    'highScore': 0,
    'money': 0,
  };
}
