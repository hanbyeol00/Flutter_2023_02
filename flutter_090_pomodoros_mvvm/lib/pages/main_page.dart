import 'package:flutter/material.dart';
import 'package:flutter_090_pomodoros/ui_model/timer_view_model.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  String _formatTime(seconds) {
    // Duration 클래스, 시, 분, 초 값을 전달받아서
    // 시:분:초 형식의 데이터로 변환시키는 클래스
    var duration = Duration(seconds: seconds);
    // return duration.toString().substring(2, 7);
    // :0:00:00

    // print(duration);
    // split(구분자)
    // 구분자를 기준으로 문자열을 분해하고,
    // 배열(List)로 변환시키는 함수
    var times = duration.toString().split(".");
    // 생성된 문자열 list times 의 0번째 index 값을 추출하고 substring 으로
    // 분해하기
    if (times.length > 6) {
      return times.first.substring(3);
    }
    return times.first.substring(2);
    // return "0:00";
  }

  @override
  Widget build(BuildContext context) {
    // var timerViewModel = context.watch<TimerViewModel>();
    var timer = context
        .select<TimerViewModel, String>((v) => _formatTime(v.timerDto.timer));
    var timeRun =
        context.select<TimerViewModel, bool>((v) => v.timerDto.timeRun);
    var onPressed =
        context.select<TimerViewModel, Function()>((v) => (v.onPressed));
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Text(
                  timer,
                  style: TextStyle(
                    fontSize: 90,
                    fontWeight: FontWeight.w900,
                    /**
                   * var Paint paint = Paint();
                   * paint.style(...)
                   * paint.strokeWidth(3)
                   * paint.color(Colors.amber)
                   */
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 5
                      ..color = Colors.white,
                  ),
                ),
                Text(
                  timer,
                  style: const TextStyle(
                    fontSize: 90,
                    fontWeight: FontWeight.w900,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: SizedBox(
        width: 200,
        height: 100,
        child: FloatingActionButton(
          backgroundColor: Colors.white38,
          elevation: 5,
          onPressed: onPressed,
          tooltip: 'Start',
          child: Icon(
            (timeRun ? Icons.pause : Icons.play_arrow),
            size: 50,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
