import 'package:flutter/material.dart';

void main() {
  runApp(FocusListApp());
}

class FocusListApp extends StatelessWidget {
  const FocusListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus List',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigoAccent,
          foregroundColor: Colors.white,
        ),
      ),
      home: FocusListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FocusListPage extends StatefulWidget {
  const FocusListPage({super.key});

  @override
  FocusListPageState createState() => FocusListPageState();
}

class FocusListPageState extends State<FocusListPage> {
  final List<Map<String, dynamic>> tasks = [];
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  void addTask() {
    if (controller.text.isNotEmpty) {
      setState(() {
        tasks.add({"text": controller.text, "done": false});
        controller.clear();
      });
      focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(title: Text('Focus List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'Tambah Task',
                hintStyle: TextStyle(color: Colors.grey[500]),

                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: addTask,
                ),
              ),
              onSubmitted: (value) => addTask(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Dismissible(
                  key: Key(task["text"]),
                  direction: DismissDirection.horizontal,
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      setState(() {
                        task["done"] = true;
                      });
                      ScaffoldMessenger.of(context)
                      ..clearSnackBars()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(
                            'Task "${task["text"]}" marked as done',
                          ),
                        ),
                      );
                      return false;
                    } else {
                      final deletedTask = task["text"];
                      setState(() {
                        tasks.removeAt(index);
                      });
                      ScaffoldMessenger.of(context)
                      ..clearSnackBars()
                      ..showSnackBar(
                        SnackBar(
                          content: Text('Task "$deletedTask" deleted'),
                        ),
                      );
                      return true;
                    }
                  },
                  background: Container(
                    color: Colors.lightGreen[400],
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.check, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red[400],
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: Text(
                      task["text"],
                      style: TextStyle(
                        decoration: task["done"]
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: task["done"]
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.grey[400]),
                      onPressed: () {
                        setState(() {
                          tasks.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Task "${tasks[index]}" deleted '),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
