import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = 'YOUR_API_KEY_HERE';

Future<Map<String, dynamic>> generateText(String prompt) async {
  const url = 'https://api.openai.com/v1/engines/davinci-codex/completions';
  final requestHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey'
  };
  final requestBody = {
    'prompt': prompt,
    'max_tokens': 50,
    'n': 1,
    'stop': '\n'
  };
  final response = await http.post(Uri.parse(url),
      headers: requestHeaders, body: json.encode(requestBody));
  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    return responseData['choices'][0]['text'];
  } else {
    throw Exception('Failed to generate text');
  }
}
