import 'dart:math';

import 'package:flame/components.dart';

import './knows_game_size.dart';

class Enemy extends SpriteComponent with KnowsGameSize {
  double _speed = 200;

  Enemy({
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
    Anchor? anchor,
  }) : super(sprite: sprite, position: position, size: size, anchor: anchor) {
    angle = pi;
  }

  @override
  void update(double dt) {
    super.update(dt);

    this.position += Vector2(0, 1) * _speed * dt;

    if (this.position.y > this.gameSize.y) {
      removeFromParent();
    }
  }
}
