import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todosapp/model/Todo.dart';
import 'package:todosapp/screens/tododetail.dart';
import 'package:todosapp/util/db_helper.dart';

class TodoList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => TodoListState();

}

class TodoListState extends State<TodoList> {

  DBHelper dbHelper = DBHelper();
  List<Todo> todoList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if(todoList == null) {
      todoList = List<Todo>();
      getData();
    }

    return Scaffold (
      body: todoListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Todo('', 3, ''));
        },
        tooltip: "Add new task",
        child: Icon(Icons.add),
      ),
    );
  }

  void getData() {
    final dbFuture = dbHelper.initializeDb();
    dbFuture.then((value)  {
      final todosFuture = dbHelper.getTodoList();
      todosFuture.then((value) {
        List<Todo> list = [];
        count =  value.length;
        value.forEach((element) {
          list.add(Todo.toObject(element));
          debugPrint(Todo.toObject(element).title);
        });
        setState(() {
          this.todoList = list;
          debugPrint("Items:" + count.toString());
        });
      });
    });
  }

  ListView todoListItems() {
    return ListView.builder(
      itemCount:count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getColorByPriority(this.todoList[position].priority),
              child: Text(this.todoList[position].priority.toString()),
            ),
            title: Text(this.todoList[position].title),
            subtitle: Text(this.todoList[position].date),
            onTap: () {
//              debugPrint("Tapped item : " + this.todoList[position].id.toString());
            navigateToDetail(this.todoList[position]);
            },
          ),
        );
      },
    );
  }

  Color getColorByPriority(int priority) {
    switch(priority) {
      case 1:
        return Colors.red;
        break;

      case 2:
        return Colors.orange;
        break;

      case 3:
        return Colors.green;
        break;

      default:
        return Colors.green;
    }
  }

  void navigateToDetail(Todo todo) async {
    bool result = await Navigator.push(context,
      MaterialPageRoute(builder: (context) => TodoDetail(todo))
    );
    if(result != null && result) {
      getData();
    }
  }
}