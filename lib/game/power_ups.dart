import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:spacescape_clone/game/command.dart';
import 'package:spacescape_clone/game/enemy.dart';

import './game.dart';
import './player.dart';

abstract class PowerUp extends SpriteComponent
    with HasGameRef<SpacescapeGame>, HasHitboxes, Collidable {
  late Timer _timer;

  Sprite getSprite();
  void onActivated();

  PowerUp({
    Vector2? position,
    Vector2? size,
    Sprite? sprite,
  }) : super(position: position, size: size, sprite: sprite) {
    _timer = Timer(3, onTick: this.removeFromParent);
  }

  @override
  void update(double dt) {
    _timer.update(dt);

    super.update(dt);
  }

  @override
  void onMount() {
    final shape = HitboxCircle(normalizedRadius: 0.5);
    addHitbox(shape);

    this.sprite = getSprite();

    // _timer.start();

    super.onMount();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is Player) {
      onActivated();
      removeFromParent();
    }

    super.onCollision(intersectionPoints, other);
  }
}

class Nuke extends PowerUp {
  Nuke({
    Vector2? position,
    Vector2? size,
  }) : super(position: position, size: size);

  @override
  Sprite getSprite() {
    return Sprite(gameRef.images.fromCache('nuke.png'));
  }

  @override
  void onActivated() {
    final command = Command<Enemy>(action: (enemy) {
      enemy.destroy();
    });
    gameRef.addCommand(command);
  }
}
