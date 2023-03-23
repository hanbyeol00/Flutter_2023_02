import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_talkwise/config/gpt_api.dart';

class HomeViewModel with ChangeNotifier {
  final SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  String lastWords = '';

  int selectedIndex = 0;

  // void onSelectedChanged(int index) {
  //   selectedIndex = index;
  //   notifyListeners();
  // }
  void onSelectedChanged(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  HomeViewModel() {
    initSpeech();
  }

  // void initSpeech() async {
  //   speechEnabled = await speechToText.initialize();
  //   notifyListeners();
  // }

  void initSpeech() async {
    speechEnabled = await speechToText.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    notifyListeners();
  }

  void startListening() async {
    await speechToText.listen(
      onResult: onSpeechResultAndSearch,
      partialResults: false,
    );
    notifyListeners();
  }

  void stopListening() async {
    await speechToText.stop();
    notifyListeners();
  }

  void onSpeechResultAndSearch(SpeechRecognitionResult result) async {
    lastWords = result.recognizedWords;
    notifyListeners();
    searchHandler(lastWords);
  }

  Future<Map<String, dynamic>> resultText = GPTAPI().generateText("");

  void searchHandler(search) {
    Future<Map<String, dynamic>> searchSpeech = GPTAPI().generateText(search);
    resultText = searchSpeech;
    notifyListeners();
  }
}
