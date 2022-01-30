import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

import './knows_game_size.dart';
import './bullet.dart';

class Enemy extends SpriteComponent
    with KnowsGameSize, HasHitboxes, Collidable {
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
  void onMount() {
    super.onMount();
    
    final shape = HitboxCircle(normalizedRadius: 0.8);
    addHitbox(shape);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);

    if (other is Bullet) {
      this.removeFromParent();
    }
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
