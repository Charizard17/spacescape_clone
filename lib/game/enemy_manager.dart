import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import './game.dart';
import './enemy.dart';
import './knows_game_size.dart';
import '../models/enemy_data.dart';

class EnemyManager extends Component
    with KnowsGameSize, HasGameRef<SpacescapeGame> {
  SpriteSheet spriteSheet;
  Random random = Random();

  late Timer _timer;
  late Timer _freezeTimer;

  EnemyManager({required this.spriteSheet}) : super() {
    _timer = Timer(1, repeat: true, onTick: _spawnEnemy);
    _freezeTimer = Timer(2, repeat: true, onTick: () {
      _timer.start();
    });
  }

  void _spawnEnemy() {
    Vector2 initialSize = Vector2(80, 80);
    Vector2 position = Vector2(random.nextDouble() * gameSize.x, 0);

    position.clamp(
        Vector2.zero() + initialSize / 2, gameSize - initialSize / 2);

    final enemyData =
        _enemyDataList.elementAt(random.nextInt(_enemyDataList.length));

    Enemy enemy = Enemy(
      sprite: spriteSheet.getSpriteById(enemyData.spriteId),
      enemyData: enemyData,
      size: initialSize,
      position: position,
      anchor: Anchor.center,
    );

    gameRef.add(enemy);
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void onRemove() {
    super.onRemove();
    _timer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);
    _freezeTimer.update(dt);
  }

  void reset() {
    _timer.stop();
    _timer.start();
  }

  void freeze() {
    _timer.stop();
    _freezeTimer.stop();
    _freezeTimer.start();
  }

  static const List<EnemyData> _enemyDataList = [
    EnemyData(
      level: 1,
      speed: 200,
      killPoint: 10,
      hMove: true,
      spriteId: 23,
    ),
    EnemyData(
      level: 1,
      speed: 225,
      killPoint: 10,
      hMove: false,
      spriteId: 14,
    ),
    EnemyData(
      level: 1,
      speed: 250,
      killPoint: 10,
      hMove: false,
      spriteId: 12,
    ),
    EnemyData(
      level: 2,
      speed: 275,
      killPoint: 10,
      hMove: true,
      spriteId: 13,
    ),
    EnemyData(
      level: 2,
      speed: 300,
      killPoint: 20,
      hMove: false,
      spriteId: 35,
    ),
    EnemyData(
      level: 2,
      speed: 350,
      killPoint: 20,
      hMove: false,
      spriteId: 36,
    ),
    EnemyData(
      level: 4,
      speed: 400,
      killPoint: 20,
      hMove: true,
      spriteId: 39,
    ),
    EnemyData(
      level: 4,
      speed: 425,
      killPoint: 20,
      hMove: false,
      spriteId: 40,
    ),
    EnemyData(
      level: 4,
      speed: 450,
      killPoint: 30,
      hMove: false,
      spriteId: 37,
    ),
    EnemyData(
      level: 5,
      speed: 500,
      killPoint: 40,
      hMove: false,
      spriteId: 1,
    ),
  ];
}
