import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flame/palette.dart';
import 'package:provider/provider.dart';

import './power_up_manager.dart';
import './power_ups.dart';
import '../widgets/overlays/game_over_menu.dart';
import '../widgets/overlays/pause_button.dart';
import '../widgets/overlays/pause_menu.dart';
import '../models/spaceship_details.dart';
import '../models/player_data.dart';
import './command.dart';
import './enemy_manager.dart';
import './knows_game_size.dart';
import './player.dart';
import './enemy.dart';
import './bullet.dart';

class SpacescapeGame extends FlameGame
    with HasCollidables, HasDraggables, HasTappables {
  final double _joystickRadius = 50;

  late Player _player;
  late SpriteSheet spriteSheet;
  late EnemyManager _enemyManager;
  late PowerUpManager _powerUpManager;
  late JoystickComponent joystick;

  late TextComponent _playerScore;
  late TextComponent _playerHealth;

  final _commandList = List<Command>.empty(growable: true);
  final _addLaterCommandList = List<Command>.empty(growable: true);

  bool _isAlreadyLoaded = false;

  @override
  Future<void>? onLoad() async {
    if (_isAlreadyLoaded == false) {
      await images.loadAll([
        'simpleSpace_tilesheet_2.png',
        'freeze.png',
        'plus.png',
        'multi_fire.png',
        'nuke.png',
      ]);

      final spaceshipType = SpaceshipType.Phoenix;
      final spaceShip = Spaceship.getSpaceshipByType(spaceshipType);

      spriteSheet = SpriteSheet.fromColumnsAndRows(
        image: images.fromCache('simpleSpace_tilesheet_2.png'),
        columns: 8,
        rows: 6,
      );

      final fireButton = HudButtonComponent(
        button: CircleComponent(
          radius: 27,
          paint: BasicPalette.white.withAlpha(100).paint(),
          anchor: Anchor.topLeft,
        ),
        buttonDown: CircleComponent(
          radius: 30,
          paint: BasicPalette.white.withAlpha(200).paint(),
          anchor: Anchor.topLeft,
        ),
        margin: const EdgeInsets.only(
          right: 30,
          bottom: 70,
        ),
        onPressed: () {
          Bullet bullet = Bullet(
            sprite: spriteSheet.getSpriteById(28),
            size: Vector2(50, 50),
            position: this._player.position,
            anchor: Anchor.center,
            level: spaceShip.level,
          );
          add(bullet);

          if (_player.isShootMultipleBullets) {
            for (int i = -1; i < 2; i += 2) {
              Bullet bullet = Bullet(
                sprite: spriteSheet.getSpriteById(28),
                size: Vector2(50, 50),
                position: this._player.position,
                anchor: Anchor.center,
                level: spaceShip.level,
              );
              bullet.direction.rotate(i * pi / 6);
              add(bullet);
            }
          }
        },
      );
      add(fireButton);

      joystick = JoystickComponent(
        knob: CircleComponent(
            radius: _joystickRadius * 0.4,
            paint: BasicPalette.white.withAlpha(100).paint()),
        background: CircleComponent(
            radius: _joystickRadius,
            paint: BasicPalette.white.withAlpha(50).paint()),
        margin: const EdgeInsets.only(left: 40, bottom: 40),
      );
      add(joystick);

      _player = Player(
        spaceshipType: spaceshipType,
        sprite: spriteSheet.getSpriteById(spaceShip.spriteId),
        size: Vector2(80, 80),
        position: Vector2(camera.canvasSize.x / 2, camera.canvasSize.y / 7 * 5),
        anchor: Anchor.center,
        joystick: joystick,
      );

      add(_player);

      _enemyManager = EnemyManager(spriteSheet: spriteSheet);
      add(_enemyManager);

      _powerUpManager = PowerUpManager();
      add(_powerUpManager);

      _playerScore = TextComponent(
        text: 'Score: 0',
        position: Vector2(10, 10),
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      );
      _playerScore.positionType = PositionType.viewport;
      add(_playerScore);

      _playerHealth = TextComponent(
        text: 'Health: 100%',
        position: Vector2(size.x - 10, 10),
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      );
      _playerHealth.anchor = Anchor.topRight;
      _playerHealth.positionType = PositionType.viewport;
      add(_playerHealth);

      _isAlreadyLoaded = true;
    }
    return super.onLoad();
  }

  @override
  void onAttach() {
    if (buildContext != null) {
      final playerData = Provider.of<PlayerData>(buildContext!, listen: false);
      _player.setSpaceshipType(playerData.spaceshipType);
    }

    super.onAttach();
  }

  @override
  void update(double dt) {
    _commandList.forEach((command) {
      children.forEach((child) {
        command.run(child);
      });
    });

    _commandList.clear();
    _commandList.addAll(_addLaterCommandList);
    _addLaterCommandList.clear();

    _playerScore.text = 'Score: ${_player.score}';
    _playerHealth.text = 'Health: ${_player.health}%';

    if (_player.health <= 0 && !camera.shaking) {
      this.pauseEngine();
      this.overlays.remove(PauseButton.ID);
      this.overlays.add(GameOverMenu.ID);
    }

    super.update(dt);
  }

  @override
  void prepare(Component c) {
    if (c is KnowsGameSize) {
      c.onGameResize(this.size);
    }

    super.prepare(c);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    this.children.whereType<KnowsGameSize>().forEach((component) {
      component.onGameResize(this.size);
    });

    super.onGameResize(canvasSize);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(size.x - 145, 10, 140 * _player.health / 100, 25),
      Paint()..color = Color.fromARGB(255, 191, 4, 4),
    );

    super.render(canvas);
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (this._player.health > 0) {
          this.pauseEngine();
          this.overlays.remove(PauseButton.ID);
          this.overlays.add(PauseMenu.ID);
        }
        break;
    }

    super.lifecycleStateChange(state);
  }

  void addCommand(Command command) {
    _addLaterCommandList.add(command);
  }

  void reset() {
    _player.reset();
    _enemyManager.reset();
    _powerUpManager.reset();

    children.whereType<Enemy>().forEach((enemy) {
      enemy.removeFromParent();
    });

    children.whereType<Bullet>().forEach((bullet) {
      bullet.removeFromParent();
    });

    children.whereType<PowerUp>().forEach((powerUp) {
      powerUp.removeFromParent();
    });
  }
}
