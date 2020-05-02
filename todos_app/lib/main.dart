import 'package:flutter/material.dart';
import 'package:todosapp/model/Todo.dart';
import 'package:todosapp/screens/todolist.dart';
import 'package:todosapp/util/db_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(title: 'Todos'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    List<Todo> todoList = [];
    DBHelper dbHelper = DBHelper();
    dbHelper.initializeDb().then(
            (result) => dbHelper.getTodoList().then(
                (row) =>  row.forEach((element) {
              todoList.add(Todo.toObject(element));
            })
        )
    );

//    DateTime today = DateTime.now();
//    Todo todo = Todo("Buy Apple", 1, today.toString(), "And make sure they are good");
//    dbHelper.insertToDo(todo);

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: TodoList()
    );
  }

}
