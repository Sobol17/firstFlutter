import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test123/main.dart';

/// страница с туду, в ней TodoList, класс с todo из todo_list.dart
class TodoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TodoList(),
    );
  }
}

/// класс с туду листом
class TodoList extends StatefulWidget {
  @override
  State<TodoList> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoList> {

  TextEditingController controller = TextEditingController();

  _toggleTodo(Todo todo, bool isChecked) {
    setState(() {
      todo.isComplete = isChecked;
    });
  }

  Widget _buildItem(BuildContext context, int index) {
    var todos = context.watch<MyAppState>().todos;

    final todo = todos[index];

    return CheckboxListTile(
      value: todo.isComplete,
      title: Text('${todo.title}'),
      onChanged: (isChecked) {
        _toggleTodo(todo, isChecked!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var todos = context.watch<MyAppState>().todos;

    addTodo() async {
      final todo = await showDialog<Todo>(
        context: context,
        builder: (BuildContext context) {
          return NewTodoDialog(controller: controller);
        },
      );
      if (todo != null) {
        setState(() {
          todos.add(todo);
        });
      }
    }
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: ListView.builder(
                itemBuilder: _buildItem,
                itemCount: todos.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton:  FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        onPressed: addTodo,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class NewTodoDialog extends StatelessWidget {
  const NewTodoDialog({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('New todo'),
      content: TextField(
        controller: controller,
        autofocus: true,
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final todo = Todo(title: controller.value.text);
            controller.clear();
            Navigator.of(context).pop(todo);
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}

class Todo {
  String? title;
  bool? isComplete;

  Todo({this.title, this.isComplete = false});
}