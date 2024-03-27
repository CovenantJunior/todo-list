import 'package:audioplayers/audioplayers.dart';

class AudioService {
  late AudioPlayer _audioPlayer;

  AudioService() {
    _audioPlayer = AudioPlayer();
  }

  void setSourceUrl(String url) {
    _audioPlayer.setSourceUrl(url);
  }
  
  void play(String url) {
    _audioPlayer.play(AssetSource(url), volume: 100);
  }

  void pause() {
    _audioPlayer.pause();
  }

  void stop() {
     _audioPlayer.stop();
  }
}
