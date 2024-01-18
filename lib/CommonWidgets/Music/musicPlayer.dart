import 'package:audioplayers/audioplayers.dart';

class MusicPlayer {
  static AudioPlayer audioPlayer = AudioPlayer();

  static void playMusic(String status) async {
    try {
      if (status == "success") {
        await audioPlayer.play(AssetSource('beepSound.mp3'));
      }
      if (status == "error") {
        await audioPlayer.play(AssetSource('error.mp3'), volume: 1);
      }
    } catch (e) {
      print(e);
    }
  }

  void dispose() {
    audioPlayer.dispose();
  }
}
