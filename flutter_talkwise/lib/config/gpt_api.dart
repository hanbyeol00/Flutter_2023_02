import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GPTAPI extends ChangeNotifier {
  String apiKey = '';

  Future<Map<String, dynamic>> generateText(String question) async {
    if (question.isEmpty) {
      return {
        'question': question,
        'answer': '질문을 입력해주세요',
      };
    }
    const url =
        'https://api.openai.com/v1/engines/text-davinci-003/completions';
    final requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey'
    };
    final requestBody = {
      'prompt': question,
      'max_tokens': 200,
      'n': 1,
    };
    final response = await http.post(Uri.parse(url),
        headers: requestHeaders, body: json.encode(requestBody));
    if (response.statusCode == 200) {
      final responseData = await json.decode(utf8.decode(response.bodyBytes));
      final answer = responseData['choices'][0]['text'];
      return {
        'question': question,
        'answer': answer,
      };
    } else {
      throw Exception('Failed to generate text');
    }
  }
}
