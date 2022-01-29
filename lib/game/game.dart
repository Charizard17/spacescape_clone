import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:spacescape_clone/game/player.dart';

class SpacescapeGame extends FlameGame with PanDetector {
  Offset? _pointerStartPosition;
  late Player player;

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
  void onPanStart(DragStartInfo info) {
    _pointerStartPosition = info.raw.globalPosition;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    final poinerCurrentPosition = info.raw.globalPosition;

    var delta = poinerCurrentPosition - _pointerStartPosition!;
    player.setMoveDirection(Vector2(delta.dx, delta.dy));
  }

  @override
  void onPanEnd(DragEndInfo info) {
    _pointerStartPosition = null;
    player.setMoveDirection(Vector2.zero());
  }

  @override
  void onPanCancel() {
    _pointerStartPosition = null;
    player.setMoveDirection(Vector2.zero());
  }
}
