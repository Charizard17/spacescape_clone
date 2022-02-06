import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:provider/provider.dart';

import '../models/settings.dart';
import './game.dart';

class AudioPlayerComponent extends Component with HasGameRef<SpacescapeGame> {
  @override
  Future<void>? onLoad() async {
    FlameAudio.bgm.initialize();

    await FlameAudio.audioCache.loadAll([
      'SynthBomb.wav',
      'laser.ogg',
      'laserSmall.ogg',
      'powerUp.ogg,'
    ]);

    return super.onLoad();
  }

  void playBackgroundMusic(String filename) {
    if (gameRef.buildContext != null) {
      if (Provider.of<Settings>(gameRef.buildContext!, listen: false)
          .backgroundMusic) {
        FlameAudio.bgm.play(filename);
      }
    }
  }

  void playSoundEffects(String filename) {
    if (gameRef.buildContext != null) {
      if (Provider.of<Settings>(gameRef.buildContext!, listen: false)
          .soundEffects) {
        FlameAudio.play(filename);
      }
    }
  }

  void stopBackgroundMusic() {
    FlameAudio.bgm.stop();
  }
}
