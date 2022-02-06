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
import './audio_player_component.dart';

class Enemy extends SpriteComponent
    with KnowsGameSize, HasHitboxes, Collidable, HasGameRef<SpacescapeGame> {
  late double _speed;
  int _hitPoints = 10;
  TextComponent _hpText = TextComponent(
    text: '10 HP',
    position: Vector2(10, 10),
    textRenderer: TextPaint(
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    ),
  );
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
    _hitPoints = enemyData.level * 10;
    _hpText.text = '$_hitPoints HP';
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

    _hpText.angle = pi;
    _hpText.position = Vector2(40, 90);
    _hpText.anchor = Anchor.center;
    add(_hpText);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);

    if (other is Bullet) {
      _hitPoints -= other.level * 10;
    } else if (other is Player) {
      _hitPoints = 0;
    }
  }

  void destroy() {
    this.removeFromParent();

    gameRef.addCommand(
      Command<AudioPlayerComponent>(
        action: (audioPlayer) {
          audioPlayer.playSoundEffects('laser.ogg');
        },
      ),
    );

    final command = Command<Player>(action: (player) {
      player.addToScore(enemyData.killPoint);
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

    _hpText.text = '$_hitPoints HP';
    _hpText.textRenderer = TextPaint(
      style: TextStyle(
        fontSize: 16,
        color: _hitPoints >= 30 ? Colors.red : Colors.amber,
      ),
    );
    if (_hitPoints <= 0) {
      destroy();
    }

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
