import 'package:flutter/material.dart';

void main() => runApp(TicTacToeApp());

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      home: TicTacToeGame(),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  late List<List<String>> _board;
  String? _userChoice;
  bool _gameOver = false;
  String _winner = '';

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    _board = List.generate(3, (_) => List.generate(3, (_) => ''));
    _gameOver = false;
    _winner = '';
  }

  void _makeMove(int row, int col) {
    if (_board[row][col] == '' && !_gameOver) {
      setState(() {
        _board[row][col] = _userChoice!;
        if (_checkWin(row, col)) {
          _gameOver = true;
          _winner = _userChoice!;
        } else if (_isBoardFull()) {
          _gameOver = true;
          _winner = 'Draw';
        }
        _userChoice = _userChoice == 'X' ? 'O' : 'X'; // Switch turn
      });
    }
  }

  bool _checkWin(int row, int col) {
    String symbol = _board[row][col];

    // Check row
    if (_board[row].every((cell) => cell == symbol)) return true;

    // Check column
    if (_board.every((row) => row[col] == symbol)) return true;

    // Check diagonal (top-left to bottom-right)
    if (row == col && _board.every((row) => row[_board.indexOf(row)] == symbol)) return true;

    // Check diagonal (top-right to bottom-left)
    if (row + col == 2 && _board.every((row) => row[2 - _board.indexOf(row)] == symbol)) return true;

    return false;
  }

  bool _isBoardFull() {
    return _board.every((row) => row.every((cell) => cell != ''));
  }

  Widget _buildBoard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (col) {
            return GestureDetector(
              onTap: () => _makeMove(row, col),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                alignment: Alignment.center,
                child: Text(
                  _board[row][col],
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  Widget _buildChoiceScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Choose Your Symbol',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _userChoice = 'X';
                    _resetGame(); // Initialize the board
                  });
                },
                child: Text('X'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _userChoice = 'O';
                    _resetGame(); // Initialize the board
                  });
                },
                child: Text('O'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGameOverScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _winner == 'Draw' ? "It's a Draw!" : '$_winner Wins!',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _userChoice = null;
                _resetGame();
              });
            },
            child: Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: _userChoice == null
          ? _buildChoiceScreen()
          : _gameOver
              ? _buildGameOverScreen()
              : _buildBoard(),
    );
  }
}
