import 'package:flutter/material.dart';
import 'package:flutter_talkwise/ui_modles/Home_View_model.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                viewModel.lastWords.isNotEmpty
                    ? viewModel.lastWords
                    : '마이크 버튼을 눌러 질문하세요',
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 70),
              ),
              onPressed: viewModel.speechToText.isNotListening
                  ? viewModel.startListening
                  : viewModel.stopListening,
              child: Icon(
                viewModel.speechToText.isNotListening
                    ? Icons.mic_off
                    : Icons.mic,
                size: 40,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: FutureBuilder<Map<String, dynamic>>(
                future: viewModel.resultText,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data;
                    final textValue = data!['answer'];
                    return Column(
                      children: [
                        Text(
                          textValue.toString(),
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        TextButton(
                          onPressed: () {
                            print(data);
                          },
                          child: const Text('카테고리에 저장하기'),
                        )
                      ],
                    );
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
