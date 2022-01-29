import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:spacescape_clone/game/player.dart';

class SpacescapeGame extends FlameGame {
  @override
  Future<void>? onLoad() async {
    await images.load('simpleSpace_tilesheet_2.png');

    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: images.fromCache('simpleSpace_tilesheet_2.png'),
      columns: 8,
      rows: 6,
    );

    Player player = Player(
      sprite: spriteSheet.getSpriteById(19),
      size: Vector2(80, 80),
      position: canvasSize / 2,
      anchor: Anchor.center,
    );

    add(player);

    return super.onLoad();
  }
}
