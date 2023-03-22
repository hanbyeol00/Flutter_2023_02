import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_talkwise/config/gpt_api.dart';

class HomeViewModel with ChangeNotifier {
  final SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  String lastWords = '';

  int selectedIndex = 0;

  void onSelectedChanged(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _initSpeech();
  // }

  void initSpeech() async {
    speechEnabled = await speechToText.initialize();
    notifyListeners();
  }

  void startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    notifyListeners();
  }

  void stopListening() async {
    await speechToText.stop();
    notifyListeners();
  }

  void onSpeechResult(SpeechRecognitionResult result) async {
    lastWords = result.recognizedWords;
    notifyListeners();
    print(lastWords);
    // searchHandler(_lastWords);
  }

  Future<Map<String, dynamic>> resultText = GPTAPI().generateText("prompt");

  void searchHandler(search) {
    Future<Map<String, dynamic>> searchSpeech = GPTAPI().generateText(search);
    resultText = searchSpeech;
    notifyListeners();
  }
}
