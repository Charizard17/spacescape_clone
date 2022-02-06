import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/particles.dart';

import '../models/enemy_data.dart';
import './command.dart';
import './knows_game_size.dart';
import './player.dart';
import './bullet.dart';
import './game.dart';

class Enemy extends SpriteComponent
    with KnowsGameSize, HasHitboxes, Collidable, HasGameRef<SpacescapeGame> {
  double _speed = 200;

  late Timer _freezeTimer;

  final EnemyData enemyData;
  Vector2 moveDirection = Vector2(0, 1);

  Random _random = Random();
  Vector2 getRandomVector() {
    return (Vector2.random(_random) - Vector2.random(_random)) * 400;
  }

  Vector2 getRandomDirection() {
    return (Vector2.random(_random) - Vector2(0.5, -2)).normalized();
  }

  Enemy({
    required Sprite? sprite,
    required this.enemyData,
    required Vector2? position,
    required Vector2? size,
    required Anchor? anchor,
  }) : super(sprite: sprite, position: position, size: size, anchor: anchor) {
    angle = pi;
    _speed = enemyData.speed;
    _freezeTimer = Timer(2, onTick: () {
      _speed = enemyData.speed;
    });

    if (enemyData.hMove) {
      moveDirection = getRandomDirection();
    }
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

  void freeze() {
    _speed = 0;
    _freezeTimer.stop();
    _freezeTimer.start();
  }

  @override
  void update(double dt) {
    super.update(dt);

    this.position += moveDirection * _speed * dt;

    if (this.position.y > this.gameSize.y) {
      removeFromParent();
    } else if ((this.position.x < this.size.x / 2) ||
        (this.position.x > (this.gameSize.x - size.x / 2))) {
      moveDirection.x *= -1;
    }
    _freezeTimer.update(dt);
  }
}
