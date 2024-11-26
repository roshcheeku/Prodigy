import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  List<String> _todoItems = [];
  List<String> _reminderItems = [];
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = IOSInitializationSettings();
    const initSettings = InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  void _addTodoItem() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _todoItems.add(_controller.text);
        _reminderItems.add(''); // Use an empty string instead of null
      });
      _controller.clear();
    }
  }

  void _deleteTodoItem(int index) {
    setState(() {
      _todoItems.removeAt(index);
      _reminderItems.removeAt(index);
    });
  }

  void _editTodoItem(int index) {
    _controller.text = _todoItems[index];
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          children: [
            TextField(
              controller: _controller,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  _todoItems[index] = _controller.text;
                });
                _controller.clear();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _scheduleNotification(int index) async {
    DateTime scheduledTime = DateTime.now().add(Duration(seconds: 10));
    String todoItem = _todoItems[index];
    const androidDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      channelDescription: 'channelDescription', // Use named parameter
      importance: Importance.max,
      priority: Priority.high,
    );
    const iOSDetails = IOSNotificationDetails();
    const notificationDetails = NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await flutterLocalNotificationsPlugin.schedule(
      index,
      'Reminder',
      todoItem,
      scheduledTime,
      notificationDetails,
    );
  }

  Widget _buildTodoItem(String todoText, int index) {
    return ListTile(
      title: Text(todoText),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.teal),
            onPressed: () => _editTodoItem(index),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteTodoItem(index),
          ),
          IconButton(
            icon: Icon(Icons.alarm, color: Colors.blue),
            onPressed: () => _scheduleNotification(index),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: _todoItems.length,
        itemBuilder: (context, index) {
          return _buildTodoItem(_todoItems[index], index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodoItem,
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Enter task',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
