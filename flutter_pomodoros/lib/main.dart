import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _time = 5;
  int _counter = 0;
  bool _timerRun = false;
  late Timer _timer;

  void _onPressed() {
    setState(() {
      _timerRun = !_timerRun;
    });
    if (_timerRun) {
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          setState(() {
            _time--;
          });
          if (_time < 1) {
            _timer.cancel();
            _time = 5;
            _timerRun = false;
            _counter++;
          }
        },
      );
    } else {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 142, 185, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(80),
              child: Time(context),
            ),
            IconButton(
              icon: _timerRun
                  ? const Icon(Icons.pause_circle_outline)
                  : const Icon(Icons.play_circle_outline),
              iconSize: 120,
              color: Colors.white,
              onPressed: _onPressed,
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              width: 450,
              height: 200,
              child: Center(child: counter()),
            ),
          ],
        ),
      ),
    );
  }

  Column counter() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Pomodoros",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          Text(
            "$_counter",
            style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
          ),
        ],
      );

  Text Time(BuildContext context) {
    return Text(
      Duration(seconds: _time).toString().substring(2, 7),
      style: const TextStyle(
        fontSize: 70,
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
    );
  }
}
