import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

import './enemy.dart';

class Bullet extends SpriteComponent with HasHitboxes, Collidable {
  double _speed = 500;
  Vector2 direction = Vector2(0, -1);

  Bullet({
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
    Anchor? anchor,
  }) : super(sprite: sprite, position: position, size: size, anchor: anchor);

  @override
  void onMount() {
    super.onMount();

    final shape = HitboxCircle(normalizedRadius: 0.4);
    addHitbox(shape);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);

    if (other is Enemy) {
      this.removeFromParent();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    this.position += direction * this._speed * dt;

    if (this.position.y < 0) {
      removeFromParent();
    }
  }
}
