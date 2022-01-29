import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:spacescape_clone/game/player.dart';

class SpacescapeGame extends FlameGame with PanDetector {
  late Player player;
  Offset? _pointerStartPosition;
  Offset? _pointerCurrentPosition;
  final double _joystickRadius = 50;
  final double _deadzoneRadius = 10;

  @override
  Future<void>? onLoad() async {
    await images.load('simpleSpace_tilesheet_2.png');

    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: images.fromCache('simpleSpace_tilesheet_2.png'),
      columns: 8,
      rows: 6,
    );

    player = Player(
      sprite: spriteSheet.getSpriteById(19),
      size: Vector2(80, 80),
      position: canvasSize / 2,
      anchor: Anchor.center,
    );

    add(player);

    return super.onLoad();
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
}
