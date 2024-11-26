import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  @override
  _CalculatorHomePageState createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String _output = "0";
  String _input = "";
  double _num1 = 0;
  double _num2 = 0;
  String _operator = "";
  List<String> _history = [];

  buttonPressed(String buttonText) {
    if (buttonText == "C") {
      _input = "";
      _output = "0";
      _num1 = 0;
      _num2 = 0;
      _operator = "";
    } else if (buttonText == "+" ||
               buttonText == "-" ||
               buttonText == "x" ||
               buttonText == "/") {
      _num1 = double.parse(_input);
      _operator = buttonText;
      _input = "";
    } else if (buttonText == ".") {
      if (_input.contains(".")) {
        return;
      } else {
        _input = _input + buttonText;
      }
    } else if (buttonText == "=") {
      _num2 = double.parse(_input);
      if (_operator == "+") {
        _output = (_num1 + _num2).toString();
      }
      if (_operator == "-") {
        _output = (_num1 - _num2).toString();
      }
      if (_operator == "x") {
        _output = (_num1 * _num2).toString();
      }
      if (_operator == "/") {
        _output = (_num1 / _num2).toString();
      }
      _input = _output;
      _history.add("$_num1 $_operator $_num2 = $_output");
      _num1 = 0;
      _num2 = 0;
      _operator = "";
    } else {
      _input = _input + buttonText;
    }

    setState(() {
      _output = _input;
    });
  }

  Widget buildButton(String buttonText) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(20),
            backgroundColor: Colors.white,
          ),
          onPressed: () => buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Flutter Calculator"),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return ListView.builder(
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_history[index]),
                      );
                    },
                  );
                },
              );
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: 12.0,
              ),
              child: Text(
                _input,
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white70,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: 12.0,
              ),
              child: Text(
                _output,
                style: TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Divider(),
            ),
            Column(children: [
              Row(children: [
                buildButton("7"),
                buildButton("8"),
                buildButton("9"),
                buildButton("/"),
              ]),
              Row(children: [
                buildButton("4"),
                buildButton("5"),
                buildButton("6"),
                buildButton("x"),
              ]),
              Row(children: [
                buildButton("1"),
                buildButton("2"),
                buildButton("3"),
                buildButton("-"),
              ]),
              Row(children: [
                buildButton("."),
                buildButton("0"),
                buildButton("00"),
                buildButton("+"),
              ]),
              Row(children: [
                buildButton("C"),
                buildButton("="),
              ]),
            ]),
          ],
        ),
      ),
    );
  }
}
