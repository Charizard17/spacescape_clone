import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

import './game.dart';
import './knows_game_size.dart';
import './enemy.dart';

class Player extends SpriteComponent
    with KnowsGameSize, HasHitboxes, Collidable, HasGameRef<SpacescapeGame> {
  Vector2 _moveDirection = Vector2.zero();
  double _speed = 300;
  final JoystickComponent joystick;

  Player({
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
    Anchor? anchor,
    required this.joystick,
  }) : super(sprite: sprite, position: position, size: size, anchor: anchor);

  @override
  void update(double dt) {
    super.update(dt);

    // this.position += _moveDirection.normalized() * _speed * dt;

    if (!joystick.delta.isZero()) {
      position.add(joystick.relativeDelta * _speed * dt);
    }

    this
        .position
        .clamp(Vector2.zero() + this.size / 2, gameSize - this.size / 2);
  }

  void setMoveDirection(Vector2 newMoveDirection) {
    _moveDirection = newMoveDirection;
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

    if (other is Enemy) {
      print('Player hit an enemy');
    }
  }
}
