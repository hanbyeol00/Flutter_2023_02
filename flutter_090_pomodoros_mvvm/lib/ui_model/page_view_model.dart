import 'package:flutter/material.dart';

class PageViewModel with ChangeNotifier {
  final _pageController = PageController(initialPage: 0);
  get pageController => _pageController;

  // 객체지향 프로그래밍에서
  // 변수를 private 은닉하고, 외부에서 접근할때는 getter, setter 를
  // 사용하는 전통적인 방법
  int _pageIndex = 0;
  get pageIndex => _pageIndex;

  void pageViewChange(newPageIndex) {
    _pageIndex = newPageIndex;
    notifyListeners();
  }

  void bottomNavTap(pageIndex) {
    _pageController.animateToPage(
      pageIndex, // 몇번페이지를 보일까
      duration: const Duration(milliseconds: 500), // 페이지 전환 시간
      curve: Curves.ease, // 애니메이션 종류
    );
    notifyListeners();
  }
}
