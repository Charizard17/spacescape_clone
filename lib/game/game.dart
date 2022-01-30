import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:spacescape_clone/game/enemy_manager.dart';

import './knows_game_size.dart';
import './player.dart';
import './enemy.dart';
import './bullet.dart';

class SpacescapeGame extends FlameGame with PanDetector, TapDetector {
  final double _joystickRadius = 50;
  final double _deadzoneRadius = 10;
  Offset? _pointerStartPosition;
  Offset? _pointerCurrentPosition;

  late Player player;
  late Enemy enemy;
  late SpriteSheet _spriteSheet;
  late EnemyManager _enemyManager;

  @override
  Future<void>? onLoad() async {
    await images.load('simpleSpace_tilesheet_2.png');

    _spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: images.fromCache('simpleSpace_tilesheet_2.png'),
      columns: 8,
      rows: 6,
    );

    player = Player(
      sprite: _spriteSheet.getSpriteById(19),
      size: Vector2(80, 80),
      position: canvasSize / 2,
      anchor: Anchor.center,
    );

    add(player);

    _enemyManager = EnemyManager(spriteSheet: _spriteSheet);
    add(_enemyManager);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    final bullets = children.whereType<Bullet>();
    final enemies = children.whereType<Enemy>();

    for (final enemy in enemies) {
      if (enemy.shouldRemove) {
        continue;
      }
      for (final bullet in bullets) {
        if (bullet.shouldRemove) {
          continue;
        }
        if (enemy.containsPoint(bullet.absoluteCenter)) {
          enemy.removeFromParent();
          bullet.removeFromParent();
          break;
        }
      }

      if (player.containsPoint(enemy.absoluteCenter)) {
        print('enemy hit to player');
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (_pointerStartPosition != null) {
      canvas.drawCircle(_pointerStartPosition!, _joystickRadius,
          Paint()..color = Colors.grey.withAlpha(50));
    }

    if (_pointerCurrentPosition != null) {
      var delta = _pointerCurrentPosition! - _pointerStartPosition!;

      if (delta.distance > _joystickRadius) {
        delta = _pointerStartPosition! +
            (Vector2(delta.dx, delta.dy).normalized() * _joystickRadius)
                .toOffset();
      } else {
        delta = _pointerCurrentPosition!;
      }

      canvas.drawCircle(delta, _joystickRadius * 0.4,
          Paint()..color = Colors.grey.withAlpha(100));
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);

    Bullet bullet = Bullet(
      sprite: _spriteSheet.getSpriteById(28),
      size: Vector2(50, 50),
      position: this.player.position,
      anchor: Anchor.center,
    );
    add(bullet);
  }

  @override
  void onPanStart(DragStartInfo info) {
    _pointerStartPosition = info.raw.globalPosition;
    _pointerCurrentPosition = info.raw.globalPosition;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    _pointerCurrentPosition = info.raw.globalPosition;

    var delta = _pointerCurrentPosition! - _pointerStartPosition!;

    if (delta.distance > _deadzoneRadius) {
      player.setMoveDirection(Vector2(delta.dx, delta.dy));
    } else {
      player.setMoveDirection(Vector2.zero());
    }
  }

  @override
  void onPanEnd(DragEndInfo info) {
    _pointerStartPosition = null;
    _pointerCurrentPosition = null;
    player.setMoveDirection(Vector2.zero());
  }

  @override
  void onPanCancel() {
    _pointerStartPosition = null;
    _pointerCurrentPosition = null;
    player.setMoveDirection(Vector2.zero());
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
