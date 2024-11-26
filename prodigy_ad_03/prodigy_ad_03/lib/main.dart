import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(TimerApp());
}

class TimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Timer',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: TimerPage(),
    );
  }
}

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Timer? _timer;
  int _milliseconds = 0;

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        _milliseconds += 10;
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _milliseconds = 0;
    });
  }

  String _formatTime(int milliseconds) {
    int minutes = (milliseconds ~/ 60000);
    int seconds = ((milliseconds % 60000) ~/ 1000);
    int millis = (milliseconds % 1000) ~/ 10;

    return '$minutes:${seconds.toString().padLeft(2, '0')}:${millis.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _formatTime(_milliseconds),
              style: TextStyle(
                fontSize: 48.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildButton(Icons.play_arrow, 'Start', _startTimer),
                SizedBox(width: 10),
                _buildButton(Icons.pause, 'Pause', _pauseTimer),
                SizedBox(width: 10),
                _buildButton(Icons.stop, 'Reset', _resetTimer),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // Background color
        foregroundColor: Colors.black, // Text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
      icon: Icon(icon, color: Colors.black),
      label: Text(label),
      onPressed: onPressed,
    );
  }
}
