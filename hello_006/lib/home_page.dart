import 'package:flutter/material.dart';
import 'package:hello_006/main_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // State<StatefulWidget> createState() {
  //   return _HomePage();
  // }
  // State 클래스의 생성자를 호출하여 StateFul 과 연결하기
  State<StatefulWidget> createState() => _HomePage();
}

/*
 * State Class 를 상속받는
 * 실제 화면을 그리는 class
 * 이 클래스는 HomePage 클래스에 의해서
 * 생성되고 데이터 변화에 따라 화면을 rendering 한다
 * State class 를 상속받는데
 * 자신의 부모(여기서는 Homepage)를 Generic type 으로
 * 만든다
 */
class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My App"),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 10,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.access_alarm),
      ),
      body: const MainBody(),
    );
  }
}
