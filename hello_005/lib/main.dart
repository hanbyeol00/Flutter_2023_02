import 'package:flutter/material.dart';

/*
 * main()
 * flutter 의 진입점 함수
 * 가장 먼저 실행되는 함수
 * main() 함수의 runApp() 함수를 통하여
 * 화면을 구현하는 class 를 호출하기
 */
void main() {
  runApp(const App());
}

/*
 * flutter 에서 화면을 구현하는 
 * 모든 도구를 Widget 이라고 한다
 * 컴포넌트(화면을 구현하는 도구)
 * 
 * StateLessWidget
 * 정적인 화면을 구현하는 Widget
 * 데이터의 변화가 없거나 그냥 보여만 주는 화면을 구현
 * 
 * StateLessWidget 을 상속받아 App 이라는 클래스를 생성하겠다
 * 상속받은 클래스에서는 build() 함수를(메서드) 재 정의하여
 * 다른 Widget 을 화면에 보여주도록 한다
 */
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    /**
     * flutter 로 만들어지는 화면을 가장 바깥쪽 box 에
     * MaterialApp() 컨테이너 Widget 으로 시작해야 한다
     */
    return MaterialApp(
      home: const Text("반갑습니다"),
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
