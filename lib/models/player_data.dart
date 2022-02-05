import 'package:flutter/material.dart';

import './spaceship_details.dart';

class PlayerData extends ChangeNotifier {
  SpaceshipType spaceshipType;
  final List<SpaceshipType> ownedSpaceships;
  final int highScore;
  int money;

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
    'money': 20000,
  };

  bool isOwned(SpaceshipType spaceshipType) {
    return this.ownedSpaceships.contains(spaceshipType);
  }

  bool canBuy(SpaceshipType spaceshipType) {
    return (this.money >= Spaceship.getSpaceshipByType(spaceshipType).cost);
  }

  bool isEquipped(SpaceshipType spaceshipType) {
    return (this.spaceshipType == spaceshipType);
  }

  void buy(SpaceshipType spaceshipType) {
    if (canBuy(spaceshipType) && !isOwned(spaceshipType)) {
      this.money -= Spaceship.getSpaceshipByType(spaceshipType).cost;
      this.ownedSpaceships.add(spaceshipType);
      notifyListeners();
    }
  }

  void equip(SpaceshipType spaceshipType) {
    this.spaceshipType = spaceshipType;
    notifyListeners();
  }
}
