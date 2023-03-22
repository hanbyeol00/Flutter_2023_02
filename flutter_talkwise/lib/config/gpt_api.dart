import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GPTAPI extends ChangeNotifier {
  String apiKey = '';

  Future<Map<String, dynamic>> generateText(String prompt) async {
    const url =
        'https://api.openai.com/v1/engines/text-davinci-003/completions';
    final requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey'
    };
    final requestBody = {
      'prompt': prompt,
      'max_tokens': 200,
      'n': 1,
    };
    print("작동됨 $prompt");
    final response = await http.post(Uri.parse(url),
        headers: requestHeaders, body: json.encode(requestBody));
    if (response.statusCode == 200) {
      final responseData = await json.decode(utf8.decode(response.bodyBytes));
      final text = responseData['choices'][0]['text'];
      print("값 도착 $text");
      return {
        'prompt': prompt,
        'text': text,
      };
    } else {
      throw Exception('Failed to generate text');
    }
  }
}
