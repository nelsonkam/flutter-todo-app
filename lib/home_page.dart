import 'package:flutter/material.dart';

import 'style.dart';
import 'todo.dart';
import 'todo_list_item.dart';

class HomePage extends StatefulWidget {
  List<Todo> todos = [
    new Todo(title: "Call Mom", description: "Tell her about the new iPhone 7"),
    new Todo(title: 'Call boss', description: "Tell I ant my vacation now !!!")
  ];
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: new Text("Todo", style: new TodoStyle(fontSize: 22.0)),
            ),
        body: new Block(
            padding: const EdgeInsets.only(top: 8.0),
            children: widget.todos
                .map((it) =>
            new TodoListItem(
                title: it.title,
                description: it.description,
                done: it.done,
                isExpanded: false,
                isFirstItem: widget.todos.indexOf(it) == 0))
                .toList(),
            ),
        floatingActionButton: new FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, "/new");
            },
            child: new Icon(Icons.add),
            ));
  }
}
