import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import './game.dart';
import './enemy.dart';
import './knows_game_size.dart';

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
    var randomEnemyId = ([3, 12, 13, 39]..shuffle()).first;

    position.clamp(
        Vector2.zero() + initialSize / 2, gameSize - initialSize / 2);

    Enemy enemy = Enemy(
      sprite: spriteSheet.getSpriteById(randomEnemyId),
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
}
