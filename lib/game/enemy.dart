import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/particles.dart';

import './command.dart';
import './knows_game_size.dart';
import './player.dart';
import './bullet.dart';
import './game.dart';

class Enemy extends SpriteComponent
    with KnowsGameSize, HasHitboxes, Collidable, HasGameRef<SpacescapeGame> {
  double _speed = 200;

  Random _random = Random();
  Vector2 getRandomVector() {
    return (Vector2.random(_random) - Vector2.random(_random)) * 400;
  }

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

    if (other is Bullet || other is Player) {
      destroy();
    }
  }

  void destroy() {
    this.removeFromParent();

    final command = Command<Player>(action: (player) {
      player.addToScore(1);
    });
    gameRef.addCommand(command);

    final particleComponent = ParticleComponent(
      Particle.generate(
        count: 15,
        lifespan: 0.1,
        generator: (index) => AcceleratedParticle(
          acceleration: getRandomVector(),
          speed: getRandomVector(),
          position: this.position,
          child: CircleParticle(
            radius: 1.5,
            paint: Paint()..color = Colors.white,
          ),
        ),
      ),
    );
    gameRef.add(particleComponent);
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
