class Todo {

  int _id;

  String _title;

  String _description;

  String _date;

  int _priority;

  // you can have only one un-named constructor in a class
  Todo(this._title, this._priority, this._date, [this._description]);

  // named constructor
  Todo.withId(this._id, this._title, this._date, this._priority, [this._description]);

  int get priority => _priority;

  set priority(int value) {
    if(value >= 0 && value <= 2) {
      _priority = value;
    } else {
      throw Exception("Prioties should between 0...2");
    }
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  String get description => _description;

  set description(String value) {
    if(value.length <= 255) {
      _description = value;
    }
  }

  String get title => _title;

  set title(String value) {
    if(value.length <= 255) {
      _title = value;
    }

  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  Map<String, dynamic> toMap() {
    var map  = Map<String, dynamic>();
    map["title"] =  _title;
    map["description"] =  _description;
    map["priority"] =  _priority;
    map["date"] =  _date;
    if(_id != null ) {
      map["id"] = _id;
    }
    return map;
  }

  Todo.toObject(dynamic obj) {
    this._id = obj["id"];
    this._title = obj["title"];
    this._description = obj["desciption"];
    this._priority = obj["priority"];
    this._date = obj["date"];
  }
}