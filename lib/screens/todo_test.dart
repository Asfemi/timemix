import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      home: ToDoList(),
    );
  }
}

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final TextEditingController _textController = TextEditingController();
  List<String> _items = [];

  Future<void> _addItem(String text) async {
    // Open the database
    Database db = await openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE todo_items(id INTEGER PRIMARY KEY, text TEXT)",
        );
      },
      version: 1,
    );

    // Insert the new item into the todo_items table
    await db.insert(
      'todo_items',
      {'text': text},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Close the database
    db.close();
  }

  Future<List> _getItems() async {
    // Open the database
    Database db = await openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      version: 1,
    );

    // Query the todo_items table for all items
    List<Map<String, dynamic>> results = await db.query('todo_items');

    // Close the database
    db.close();

    // Convert the List of Maps to a List of Strings
    return results.map((item) => item['text']).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _textController,
          ),
          ElevatedButton(
            child: Text('Add'),
            onPressed: () {
              setState(() {
                _items.add(_textController.text);
                _textController.clear();
              });
              _addItem(_textController.text);
            },
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _getItems(),
              initialData: [],
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data.toString()),
                      );
                  }
                );
              }
            ),
          ),
        ]
      ),
    );
    
  }
}


//1.The MyApp class extends StatelessWidget and overrides the build 
//method to return a MaterialApp widget,
//which is the root of the app. The home property is set to the ToDoList 
//widget, which is defined later in the code.

//2.The ToDoList class extends StatefulWidget and overrides the createState 
//method to return an instance 
//of the _ToDoListState class, which will hold the state for the to-do list.

//3.The _ToDoListState class extends State and defines a TextEditingController 
//named _textController, 
//a list of strings named _items, and three methods: _addItem, _getItems, and build.

//4.The _addItem method takes a string as an argument and is used to insert a 
//new to-do item into the local database. It first opens the database using 
//the openDatabase function and then inserts a new row 
//into the todo_items table using the insert method. Finally, it closes the database.

//5.The _getItems method is used to retrieve all of the to-do items from the local database. 
//It opens the database, queries the todo_items table, closes the database, 
//and returns the list of items as a list of strings.

//6.The build method returns a Scaffold widget with an app bar and a column
// containing a text field, a button, and a list view. The text field uses 
//the _textController as its controller, and the button's 
//onPressed callback is used to add a new item to the list and insert 
//it into the database. The list view uses a FutureBuilder to 
//display the list of items from the database, and each item is displayed as a ListTile widget.

//I hope this helps to clarify the code that I provided. Let me know if you have any further questions!