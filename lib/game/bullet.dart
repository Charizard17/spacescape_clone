import 'package:flame/components.dart';

class Bullet extends SpriteComponent {
  double _speed = 500;

  Bullet({
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
    Anchor? anchor,
  }) : super(sprite: sprite, position: position, size: size, anchor: anchor);

  @override
  void update(double dt) {
    super.update(dt);

    this.position += Vector2(0, -1) * this._speed * dt;

    if (this.position.y < 0) {
      removeFromParent();
    }
  }
}
