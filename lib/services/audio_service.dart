import 'package:flutter/services.dart';

class AudioService {
  static Future<void> playTimerComplete() async {
    await SystemSound.play(SystemSoundType.alert);
  }

  static Future<void> playBreakStart() async {
    await SystemSound.play(SystemSoundType.click);
  }

  static Future<void> playSessionEnd() async {
    await SystemSound.play(SystemSoundType.alert);
  }
}
