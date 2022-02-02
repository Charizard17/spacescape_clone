import 'dart:ui';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

import './game.dart';
import './knows_game_size.dart';
import './enemy.dart';

class Player extends SpriteComponent
    with KnowsGameSize, HasHitboxes, Collidable, HasGameRef<SpacescapeGame> {
  final JoystickComponent joystick;

  Vector2 _moveDirection = Vector2.zero();
  double _speed = 300;
  int _score = 0;
  int get score => _score;
  int _health = 100;
  int get health => _health;

  Random _random = Random();
  Vector2 getRandomVector() {
    return (Vector2.random(_random) - Vector2(0.5, -2)) * 250;
  }

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

    final particleComponent = ParticleComponent(
      Particle.generate(
        count: 10,
        lifespan: 0.1,
        generator: (index) => AcceleratedParticle(
          acceleration: getRandomVector(),
          speed: getRandomVector(),
          position: this.position.clone() + Vector2(0, this.size.y / 3.5),
          child: CircleParticle(
            radius: 1,
            paint: Paint()..color = Colors.white,
          ),
        ),
      ),
    );
    gameRef.add(particleComponent);
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
      gameRef.camera.shake();

      _health -= 10;
      if (_health <= 0) {
        _health = 0;
      }
    }
  }

  void addToScore(int points) {
    _score += points;
  }

  void reset() {
    this._score = 0;
    this._health = 100;
    this.position = Vector2(
        gameRef.camera.canvasSize.x / 2, gameRef.camera.canvasSize.y / 7 * 5);
  }
}
