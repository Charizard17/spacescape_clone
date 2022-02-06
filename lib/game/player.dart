import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/particles.dart';
import 'package:provider/provider.dart';
import 'package:spacescape_clone/models/player_data.dart';

import './game.dart';
import './knows_game_size.dart';
import './enemy.dart';
import '../models/spaceship_details.dart';

class Player extends SpriteComponent
    with KnowsGameSize, HasHitboxes, Collidable, HasGameRef<SpacescapeGame> {
  final JoystickComponent joystick;

  Vector2 _moveDirection = Vector2.zero();
  int _health = 100;
  int get health => _health;

  SpaceshipType spaceshipType;
  Spaceship _spaceship;

  late PlayerData _playerData;
  // after _playerData initialized, _score will equal to _playerData.currentScore
  int _score = 0;
  int get score => _score;

  bool _shootMultipleBullets = false;
  bool get isShootMultipleBullets => _shootMultipleBullets;
  late Timer _powerUpTimer;

  Random _random = Random();
  Vector2 getRandomVector() {
    return (Vector2.random(_random) - Vector2(0.5, -2)) * 250;
  }

  Player({
    required this.spaceshipType,
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
    Anchor? anchor,
    required this.joystick,
  })  : this._spaceship = Spaceship.getSpaceshipByType(spaceshipType),
        super(sprite: sprite, position: position, size: size, anchor: anchor) {
    _powerUpTimer = Timer(4, onTick: () {
      _shootMultipleBullets = false;
    });
  }

  @override
  void update(double dt) {
    super.update(dt);

    this.position += _moveDirection.normalized() * _spaceship.speed * dt;

    if (!joystick.delta.isZero()) {
      position.add(joystick.relativeDelta * _spaceship.speed * dt);
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

    if (gameRef.buildContext != null) {
      _playerData =
          Provider.of<PlayerData>(gameRef.buildContext!, listen: false);
      _score = _playerData.currentScore;
    }

    _powerUpTimer.update(dt);
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
      gameRef.camera.shake(intensity: 10);

      _health -= 10;
      if (_health <= 0) {
        _health = 0;
      }
    }
  }

  void addToScore(int points) {
    _playerData.currentScore += points;
    _playerData.money += points;

    _playerData.save();
  }

  void increaseHealthBy(int points) {
    _health += points;
    if (_health > 100) {
      _health = 100;
    }
  }

  void reset() {
    _playerData.currentScore = 0;
    this._health = 100;
    this.position = Vector2(
        gameRef.camera.canvasSize.x / 2, gameRef.camera.canvasSize.y / 7 * 5);
  }

  void setSpaceshipType(SpaceshipType spaceshipType) {
    this.spaceshipType = spaceshipType;
    this._spaceship = Spaceship.getSpaceshipByType(spaceshipType);
    sprite = gameRef.spriteSheet.getSpriteById(_spaceship.spriteId);
  }

  void shootMultipleBullets() {
    _shootMultipleBullets = true;
    _powerUpTimer.stop();
    _powerUpTimer.start();
  }
}
