import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green, // Change primary color to green
      ),
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<TodoItem> todos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return Card( // Wrap each todo in a card for better visual separation
            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: ListTile(
              title: todos[index],
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      _editTodo(context, index); // Call edit todo function
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      _deleteTodo(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodo(context);
        },
        tooltip: 'Add Todo',
        child: Icon(Icons.add),
      ),
    );
  }

  void _addTodo(BuildContext context) async {
    final TextEditingController controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Todo'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter your todo'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  final todoText = controller.text;
                  if (todoText.isNotEmpty) {
                    todos.add(
                      TodoItem(
                        title: todoText,
                        onChanged: (isChecked) {
                          // Handle checkbox state change
                          setState(() {
                            // Update the value of the todo based on checkbox state
                          });
                        },
                      ),
                    );
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editTodo(BuildContext context, int index) async {
    final TextEditingController controller =
    TextEditingController(text: todos[index].title);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Todo'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter your todo'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  final todoText = controller.text;
                  if (todoText.isNotEmpty) {
                    todos[index] = TodoItem(
                      title: todoText,
                      onChanged: todos[index].onChanged,
                    );
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
  }
}

class TodoItem extends StatefulWidget {
  final String title;
  final Function(bool?) onChanged;

  TodoItem({required this.title, required this.onChanged});

  @override
  _TodoItemState createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  bool isChecked = false;
  late Color backgroundColor;
  late TextStyle textStyle;

  @override
  void initState() {
    super.initState();
    backgroundColor = _generateRandomColor();
    textStyle = TextStyle(
      color: Colors.black87, // Set text color to black
      decoration: isChecked ? TextDecoration.lineThrough : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400), // Add border to container
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: CheckboxListTile(
        title: Text(
          widget.title,
          style: textStyle,
        ),
        value: isChecked,
        onChanged: (value) {
          setState(() {
            isChecked = value!;
            textStyle = TextStyle(
              color: Colors.black87,
              decoration: isChecked ? TextDecoration.lineThrough : null,
            );
          });
          widget.onChanged(value);
        },
      ),
    );
  }

  Color _generateRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}
