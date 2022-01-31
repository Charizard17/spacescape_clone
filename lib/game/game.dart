import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flame/palette.dart';

import './enemy_manager.dart';
import './knows_game_size.dart';
import './player.dart';
import './enemy.dart';
import './bullet.dart';

class SpacescapeGame extends FlameGame
    with HasCollidables, HasDraggables, HasTappables {
  final double _joystickRadius = 50;

  late Player player;
  late Enemy enemy;
  late SpriteSheet _spriteSheet;
  late EnemyManager _enemyManager;
  late JoystickComponent joystick;

  @override
  Future<void>? onLoad() async {
    await images.load('simpleSpace_tilesheet_2.png');

    _spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: images.fromCache('simpleSpace_tilesheet_2.png'),
      columns: 8,
      rows: 6,
    );

    final fireButton = HudButtonComponent(
      button: CircleComponent(
        radius: 25,
        anchor: Anchor.center,
        paint: BasicPalette.white.withAlpha(100).paint(),
      ),
      buttonDown: CircleComponent(
        radius: 28,
        paint: BasicPalette.white.withAlpha(200).paint(),
        anchor: Anchor.center,
      ),
      margin: const EdgeInsets.only(
        right: 20,
        bottom: 60,
      ),
      onPressed: () {
        Bullet bullet = Bullet(
          sprite: _spriteSheet.getSpriteById(28),
          size: Vector2(50, 50),
          position: this.player.position,
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

    player = Player(
      sprite: _spriteSheet.getSpriteById(19),
      size: Vector2(80, 80),
      position: canvasSize / 2,
      anchor: Anchor.center,
      joystick: joystick,
    );

    add(player);

    _enemyManager = EnemyManager(spriteSheet: _spriteSheet);
    add(_enemyManager);

    return super.onLoad();
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
}
