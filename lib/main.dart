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
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: FocusListPage(),
    );
  }
}

class FocusListPage extends StatefulWidget {
  const FocusListPage({super.key});

  @override
  FocusListPageState createState() => FocusListPageState();
}

class FocusListPageState extends State<FocusListPage> {
  final List<String> tasks = [];
  final TextEditingController controller = TextEditingController();

  void addTask() {
    if (controller.text.isNotEmpty) {
      setState(() {
        tasks.add(controller.text);
        controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Focus List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Tambah Task',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: addTask,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(tasks[index]));
              },
            ),
          ),
        ],
      ),
    );
  }
}
