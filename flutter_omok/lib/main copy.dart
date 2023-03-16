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

  void resetBoard() {
    setState(() {
      board = List.generate(15, (_) => List.filled(15, 0));
      currentPlayer = 1;
      gameOver = false;
    });
  }

  bool checkWin(int row, int col) {
    // Check horizontal
    int count = 1;
    for (int i = col - 1; i >= 0 && board[row][i] == currentPlayer; i--) {
      count++;
    }
    for (int i = col + 1; i < 15 && board[row][i] == currentPlayer; i++) {
      count++;
    }
    if (count >= 5) return true;

    // Check vertical
    count = 1;
    for (int i = row - 1; i >= 0 && board[i][col] == currentPlayer; i--) {
      count++;
    }
    for (int i = row + 1; i < 15 && board[i][col] == currentPlayer; i++) {
      count++;
    }
    if (count >= 5) return true;

    // Check diagonal (top-left to bottom-right)
    count = 1;
    for (int i = row - 1, j = col - 1;
        i >= 0 && j >= 0 && board[i][j] == currentPlayer;
        i--, j--) {
      count++;
    }
    for (int i = row + 1, j = col + 1;
        i < 15 && j < 15 && board[i][j] == currentPlayer;
        i++, j++) {
      count++;
    }
    if (count >= 5) return true;

    // Check diagonal (bottom-left to top-right)
    count = 1;
    for (int i = row + 1, j = col - 1;
        i < 15 && j >= 0 && board[i][j] == currentPlayer;
        i++, j--) {
      count++;
    }
    for (int i = row - 1, j = col + 1;
        i >= 0 && j < 15 && board[i][j] == currentPlayer;
        i--, j++) {
      count++;
    }
    if (count >= 5) return true;

    return false;
  }

  void placeStone(int row, int col) {
    if (gameOver || board[row][col] != 0) return;
    if (board[row][col] != 0) return; // Position is already occupied

    setState(() {
      board[row][col] = currentPlayer;

      if (checkWin(row, col)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('${currentPlayer == 1 ? "Black" : "White"} player wins!'),
          ),
        );
        gameOver = true;
      } else {
        // Switch to the next player
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
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
