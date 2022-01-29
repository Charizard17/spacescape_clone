import 'package:flame/components.dart';
import './knows_game_size.dart';

class Player extends SpriteComponent with KnowsGameSize {
  Vector2 _moveDirection = Vector2.zero();
  double _speed = 300;

  Player({
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
    Anchor? anchor,
  }) : super(sprite: sprite, position: position, size: size, anchor: anchor);

  @override
  void update(double dt) {
    super.update(dt);

    this.position += _moveDirection.normalized() * _speed * dt;

    this
        .position
        .clamp(Vector2.zero() + this.size / 2, gameSize - this.size / 2);
  }

  void setMoveDirection(Vector2 newMoveDirection) {
    _moveDirection = newMoveDirection;
  }
}
