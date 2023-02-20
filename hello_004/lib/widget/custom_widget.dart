import 'package:flutter/material.dart';

class CustomWidget extends StatelessWidget {
  const CustomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            Text(
              "Hello Han",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
            ),
            Text(
              "gksquf6670@gmail.com",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
