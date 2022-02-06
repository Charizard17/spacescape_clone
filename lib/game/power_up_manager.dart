import 'dart:math';

import 'package:flame/components.dart';

import './power_ups.dart';
import './game.dart';
import './enemy.dart';
import './knows_game_size.dart';

enum PowerUpTypes { Health, Nuke, Freeze, MultiFire }

class PowerUpManager extends Component
    with KnowsGameSize, HasGameRef<SpacescapeGame> {
  Random random = Random();

  late Timer _spawnTimer;
  late Timer _freezeTimer;

  static late Sprite nukeSprite;
  static late Sprite healthSprite;
  static late Sprite freezeSprite;
  static late Sprite multiFireSprite;

  static Map<PowerUpTypes, PowerUp Function(Vector2 position, Vector2 size)>
      _powerUpMap = {
    PowerUpTypes.Health: ((position, size) => Health(
          position: position,
          size: size,
        )),
    PowerUpTypes.Nuke: ((position, size) => Nuke(
          position: position,
          size: size,
        )),
    PowerUpTypes.Freeze: ((position, size) => Freeze(
          position: position,
          size: size,
        )),
    PowerUpTypes.MultiFire: ((position, size) => MultiFire(
          position: position,
          size: size,
        )),
  };

  PowerUpManager() : super() {
    _spawnTimer = Timer(5, repeat: true, onTick: _spawnPowerUp);
    _freezeTimer = Timer(2, onTick: () {
      _spawnTimer.start();
    });
  }

  void _spawnPowerUp() {
    Vector2 initialSize = Vector2(64, 64);
    Vector2 position = Vector2(
      random.nextDouble() * gameSize.x,
      random.nextDouble() * gameSize.y,
    );

    position.clamp(
        Vector2.zero() + initialSize / 2, gameSize - initialSize / 2);

    int randomIndex = random.nextInt(PowerUpTypes.values.length);
    final fn = _powerUpMap[PowerUpTypes.values.elementAt(randomIndex)];

    var powerUp = fn?.call(position, initialSize);
    powerUp?.anchor = Anchor.center;

    if (powerUp != null) {
      gameRef.add(powerUp);
    }
  }

  @override
  void onMount() {
    _spawnTimer.start();

    nukeSprite = Sprite(gameRef.images.fromCache('nuke.png'));
    healthSprite = Sprite(gameRef.images.fromCache('plus.png'));
    freezeSprite = Sprite(gameRef.images.fromCache('freeze.png'));
    multiFireSprite = Sprite(gameRef.images.fromCache('multi_fire.png'));

    super.onMount();
  }

  @override
  void onRemove() {
    _spawnTimer.stop();

    super.onRemove();
  }

  @override
  void update(double dt) {
    _spawnTimer.update(dt);
    _freezeTimer.update(dt);

    super.update(dt);
  }

  void reset() {
    _spawnTimer.stop();
    _spawnTimer.start();
  }

  void freeze() {
    _spawnTimer.stop();
    _freezeTimer.stop();
    _freezeTimer.start();
  }
}
