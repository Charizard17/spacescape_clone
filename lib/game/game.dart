import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flame/palette.dart';

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
  late JoystickComponent joystick;

  late TextComponent _playerScore;
  late TextComponent _playerHealth;

  final _commandList = List<Command>.empty(growable: true);
  final _addLaterCommandList = List<Command>.empty(growable: true);

  @override
  Future<void>? onLoad() async {
    await images.load('simpleSpace_tilesheet_2.png');

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
        );
        add(bullet);
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
      sprite: spriteSheet.getSpriteById(19),
      size: Vector2(80, 80),
      position: canvasSize / 2,
      anchor: Anchor.center,
      joystick: joystick,
    );

    add(_player);

    _enemyManager = EnemyManager(spriteSheet: spriteSheet);
    add(_enemyManager);

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

    this.camera.defaultShakeIntensity = 10;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

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
  }

  @override
  void prepare(Component c) {
    super.prepare(c);

    if (c is KnowsGameSize) {
      c.onGameResize(this.size);
    }
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);

    this.children.whereType<KnowsGameSize>().forEach((component) {
      component.onGameResize(this.size);
    });
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(size.x - 145, 10, 140 * _player.health / 100, 25),
      Paint()..color = Color.fromARGB(255, 191, 4, 4),
    );
    super.render(canvas);
  }

  void addCommand(Command command) {
    _addLaterCommandList.add(command);
  }
}
