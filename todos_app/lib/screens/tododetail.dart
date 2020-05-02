import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todosapp/model/Todo.dart';
import 'package:todosapp/util/db_helper.dart';


DBHelper dbHelper = DBHelper();

final List<String> choices = const <String>[
  "Save to and back",
  "Delete to do",
  'Back to list'
];


const menuSave = 'Save to and back';
const menuDelete = "Delete to do";
const menuBack = 'Back to list';

class TodoDetail extends StatefulWidget {

  final Todo todo;

  TodoDetail(this.todo);

  @override
  State<StatefulWidget> createState() => TodoDetailState(todo);

}

class TodoDetailState extends State<TodoDetail> {

  Todo todo;
  final _priorities = ["High", "Medium", "Low"];
  String _priority = "Low";

  TodoDetailState(this.todo);

  TextEditingController titleEditingController = TextEditingController();
  TextEditingController descriptionEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //initialize
    titleEditingController.text = todo.title;
    descriptionEditingController.text = todo.description;
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // to hide back button
        title: Text(
          this.todo.title
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) => onOptionSelected(value),
            itemBuilder: (BuildContext context) {
              return choices.map((String value) {
                return PopupMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList();
            },
          )
        ],
      ),

      body: Padding(
      padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10),
      child: Column(
        children: <Widget>[
          TextField(
            controller: titleEditingController,
            style: textStyle,
            onChanged: (value) => this.updateTitle(),
            decoration: InputDecoration(
              labelText: "Title",
              labelStyle: textStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              )
            ),
          ),

          Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: descriptionEditingController,
                style: textStyle,
                onChanged: (value) => this.updateDescription(),
                decoration: InputDecoration(
                    labelText: "Description",
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )
                ),
              )
          ),

          DropdownButton<String>(
            items: _priorities.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            value: getStringPriority(todo.priority),
            onChanged: (value) => updatePriority(value),
            style: textStyle,
          )
        ],
      ),
      )
    );
  }

  void onOptionSelected(String value) async {
     int result;
     switch(value) {
       case menuSave:
         save();
         break;

       case menuDelete:
         Navigator.pop(context, true);
         if(todo.id == null) {
           return;
         }
         result = await dbHelper.delete(todo.id);
         if(result != 0) {
           var alertDialog = AlertDialog(
             title: Text("Delete todo"),
             content: Text("The todo has been deleted!"),
           );
           showDialog(context: context,
             builder: (_) => alertDialog);
         }
         break;

       case menuBack:
        Navigator.pop(context, true);
        break;
       default:
     }
  }

  // This also could be asynchronous
  void save() {
    todo.date = new DateFormat.yMd().format(DateTime.now());
    if(todo.id != null) {
      dbHelper.updateTodo(todo);
    } else {
      dbHelper.insertToDo(todo);
    }
    Navigator.pop(context, true);
  }

  void updatePriority(String priority) {
     switch(priority) {
       case "Low":
         todo.priority = 1;
         break;

       case "Medium":
         todo.priority = 2;
         break;

       case "High":
         todo.priority = 3;
         break;
     }
     setState(() {
       _priority = priority;
     });
  }

  String getStringPriority(int priority) {
     return _priorities[priority -1];
  }

  void updateTitle() {
    todo.title = titleEditingController.text;
  }

  void updateDescription() {
    todo.description = descriptionEditingController.text;
  }
}