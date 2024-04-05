import 'dart:ui' as ui;

import 'package:flutter_tts/flutter_tts.dart';

class STT {

  FlutterTts flutterTts = FlutterTts();

  String getSystemLanguage() {
    // Get the locale of the window
    ui.Locale locale = ui.window.locale;

    // Construct the language code in the format "en-US"
    String languageCode = locale.languageCode;
    String? countryCode = locale.countryCode;
    return countryCode != null ? '$languageCode-$countryCode' : languageCode;
  }

  Future speak(plan) async{
    await flutterTts.isLanguageInstalled(getSystemLanguage()) ? await flutterTts.setVoice({"name": "Karen", "locale": getSystemLanguage()}) : await flutterTts.setVoice({"name": "Karen", "locale": "en-US"});
    await flutterTts.setSpeechRate(1.0);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(plan);
  }
  
}