import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Omok Game',
      home: OmokBoard(),
    );
  }
}

class OmokBoard extends StatefulWidget {
  const OmokBoard({Key? key}) : super(key: key);

  @override
  _OmokBoardState createState() => _OmokBoardState();
}

class _OmokBoardState extends State<OmokBoard> {
  List<List<int>> board = List.generate(15, (_) => List.filled(15, 0));

  int currentPlayer = 1;
  bool gameOver = false;
  bool gameOverline = false;

  void resetBoard() {
    setState(() {
      board = List.generate(15, (_) => List.filled(15, 0));
      currentPlayer = 1;
      gameOver = false;
      gameOverline = false;
    });
  }

  bool checkWin(int row, int col) {
    final directions = [
      [1, 0],
      [0, 1],
      [1, 1],
      [1, -1],
    ];

    for (final direction in directions) {
      int count = 1;
      int dx = direction[0];
      int dy = direction[1];

      for (int i = 1; i < 5; i++) {
        int r = row + i * dy;
        int c = col + i * dx;

        if (r < 0 || r >= 15 || c < 0 || c >= 15) {
          break;
        }

        if (board[r][c] == currentPlayer) {
          count++;
        } else {
          break;
        }
      }

      dx = -dx;
      dy = -dy;
      for (int i = 1; i < 5; i++) {
        int r = row + i * dy;
        int c = col + i * dx;

        if (r < 0 || r >= 15 || c < 0 || c >= 15) {
          break;
        }

        if (board[r][c] == currentPlayer) {
          count++;
        } else {
          break;
        }
      }

      if (count == 5) {
        return true;
      } else if (count > 5) {
        gameOverline = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('장목! 다른 곳에 두세요.'),
          ),
        );
      }
    }

    return false;
  }

  void placeStone(int row, int col) async {
    if (gameOver || board[row][col] != 0) return;

    setState(() {
      board[row][col] = currentPlayer;

      if (checkWin(row, col)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${currentPlayer == 1 ? "검정" : "흰색"} 플레이어 승리!'),
          ),
        );
        gameOver = true;
      } else if (board.every((row) => row.every((stone) => stone != 0))) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("무승부?"),
          ),
        );
        gameOver = true;
      } else {
        currentPlayer = currentPlayer == 1 ? 2 : 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Omok Game'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: Colors.brown[300],
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 15,
              ),
              itemCount: 225,
              itemBuilder: (BuildContext context, int index) {
                int row = index ~/ 15;
                int col = index % 15;
                15;
                return GestureDetector(
                  onTap: () {
                    placeStone(row, col);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: board[row][col] == 0
                          ? null
                          : CircleAvatar(
                              backgroundColor: board[row][col] == 1
                                  ? Colors.black
                                  : Colors.white,
                              radius: 15,
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: resetBoard,
            child: const Text('리셋'),
          ),
        ],
      ),
    );
  }
}
