import 'package:hive/hive.dart';

part 'spaceship_details.g.dart';

class Spaceship {
  final String name;
  final int cost;
  final double speed;
  final int spriteId;
  final String assetPath;
  final int level;

  const Spaceship({
    required this.name,
    required this.cost,
    required this.speed,
    required this.spriteId,
    required this.assetPath,
    required this.level,
  });

  static Spaceship getSpaceshipByType(SpaceshipType spaceshipType) {
    return spaceships[spaceshipType] ?? spaceships.entries.first.value;
  }

  static const Map<SpaceshipType, Spaceship> spaceships = {
    SpaceshipType.Phoenix: Spaceship(
      name: 'Phoenix',
      cost: 0,
      speed: 250,
      spriteId: 0,
      assetPath: 'assets/images/Phoenix.png',
      level: 1,
    ),
    SpaceshipType.Defcom: Spaceship(
      name: 'Defcom',
      cost: 100,
      speed: 300,
      spriteId: 2,
      assetPath: 'assets/images/Defcom.png',
      level: 2,
    ),
    SpaceshipType.Liberator: Spaceship(
      name: 'Liberator',
      cost: 300,
      speed: 300,
      spriteId: 4,
      assetPath: 'assets/images/Liberator.png',
      level: 2,
    ),
    SpaceshipType.Piranha: Spaceship(
      name: 'Piranha',
      cost: 500,
      speed: 325,
      spriteId: 7,
      assetPath: 'assets/images/Piranha.png',
      level: 3,
    ),
    SpaceshipType.Leonov: Spaceship(
      name: 'Leonov',
      cost: 700,
      speed: 400,
      spriteId: 9,
      assetPath: 'assets/images/Leonov.png',
      level: 3,
    ),
    SpaceshipType.Bigboy: Spaceship(
      name: 'Bigboy',
      cost: 1000,
      speed: 400,
      spriteId: 18,
      assetPath: 'assets/images/Bigboy.png',
      level: 4,
    ),
    SpaceshipType.Vengeance: Spaceship(
      name: 'Vengeance',
      cost: 1300,
      speed: 450,
      spriteId: 17,
      assetPath: 'assets/images/Vengeance.png',
      level: 4,
    ),
    SpaceshipType.Goliath: Spaceship(
      name: 'Goliath',
      cost: 2000,
      speed: 450,
      spriteId: 19,
      assetPath: 'assets/images/Goliath.png',
      level: 5,
    ),
  };
}

@HiveType(typeId: 1)
enum SpaceshipType {
  @HiveField(0)
  Phoenix,
  @HiveField(1)
  Defcom,
  @HiveField(2)
  Liberator,
  @HiveField(3)
  Piranha,
  @HiveField(4)
  Leonov,
  @HiveField(5)
  Bigboy,
  @HiveField(6)
  Vengeance,
  @HiveField(7)
  Goliath,
}
