// }
// 	}
// 		);
// 			),
// 				child: const Icon(Icons.add),
// 				},
// 					}
// 						_addItem(_controller.text);
// 					} else {
// 						FocusScope.of(context).requestFocus(FocusNode());
// 						// focus the text field
// 					if (_controller.text.trim().isEmpty) {
// 				onPressed: () {
// 			floatingActionButton: FloatingActionButton(
// 			),
// 				],
// 					),
// 									),
// 										},
// 											);
// 												),
// 													),
// 														onPressed: () => _deleteItem(item.id),
// 														icon: const Icon(Icons.delete_outline),
// 													trailing: IconButton(
// 													onTap: () => _editItem(item),
// 													),
// 														),
// 															color: item.done ? Colors.black45 : null,
// 																	item.done ? TextDecoration.lineThrough : null,
// 															decoration:
// 														style: TextStyle(
// 														item.title,
// 													title: Text(
// 													),
// 														onChanged: (_) => _toggleDone(item),
// 														value: item.done,
// 													leading: Checkbox(
// 												child: ListTile(
// 												onDismissed: (_) => _deleteItem(item.id),
// 												),
// 													child: const Icon(Icons.delete, color: Colors.white),
// 													padding: const EdgeInsets.only(right: 20),
// 													alignment: Alignment.centerRight,
// 													color: Colors.red,
// 												background: Container(
// 												direction: DismissDirection.endToStart,
// 												key: ValueKey(item.id),
// 											return Dismissible(
// 											final item = _items[index];
// 										itemBuilder: (context, index) {
// 										itemCount: _items.length,
// 										padding: const EdgeInsets.symmetric(vertical: 8),
// 								: ListView.builder(
// 									)
// 										),
// 											style: TextStyle(color: Colors.black54),
// 											'No todos yet. Add one above.',
// 										child: Text(
// 								? const Center(
// 						child: _items.isEmpty
// 					Expanded(
// 					const Divider(height: 1),
// 					),
// 						),
// 							],
// 								),
// 									child: const Icon(Icons.add),
// 									onPressed: () => _addItem(_controller.text),
// 								ElevatedButton(
// 								const SizedBox(width: 8),
// 								),
// 									),
// 										onSubmitted: _addItem,
// 										),
// 											isDense: true,
// 											border: OutlineInputBorder(),
// 											hintText: 'Add a new todo',
// 										decoration: const InputDecoration(
// 										controller: _controller,
// 									child: TextField(
// 								Expanded(
// 							children: [
// 						child: Row(
// 						padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
// 					Padding(
// 				children: [
// 			body: Column(
// 			),
// 				],
// 					),
// 						onPressed: _items.any((it) => it.done) ? _clearCompleted : null,
// 						icon: const Icon(Icons.delete_sweep),
// 						tooltip: 'Clear completed',
// 					IconButton(
// 				actions: [
// 				title: Text('Todo List ($remaining)'),
// 			appBar: AppBar(
// 		return Scaffold(
// 		final remaining = _items.where((it) => !it.done).length;
// 	Widget build(BuildContext context) {
// 	@override

// 	}
// 		setState(() => _items.removeWhere((it) => it.done));
// 	void _clearCompleted() {

// 	}
// 		}
// 			setState(() => item.title = result.trim());
// 		if (result != null && result.trim().isNotEmpty) {

// 		);
// 			},
// 				);
// 					],
// 						),
// 							child: const Text('Save'),
// 							onPressed: () => Navigator.of(context).pop(editController.text),
// 						ElevatedButton(
// 						),
// 							child: const Text('Cancel'),
// 							onPressed: () => Navigator.of(context).pop(),
// 						TextButton(
// 					actions: [
// 					),
// 						onSubmitted: (v) => Navigator.of(context).pop(v),
// 						autofocus: true,
// 						controller: editController,
// 					content: TextField(
// 					title: const Text('Edit todo'),
// 				return AlertDialog(
// 				final editController = TextEditingController(text: item.title);
// 			builder: (context) {
// 			context: context,
// 		final result = await showDialog<String>(
// 	void _editItem(TodoItem item) async {

// 	}
// 		setState(() => _items.removeWhere((it) => it.id == id));
// 	void _deleteItem(String id) {

// 	}
// 		setState(() => item.done = !item.done);
// 	void _toggleDone(TodoItem item) {

// 	}
// 		});
// 			_controller.clear();
// 			);
// 				),
// 					title: trimmed,
// 					id: DateTime.now().microsecondsSinceEpoch.toString(),
// 				TodoItem(
// 				0,
// 			_items.insert(
// 		setState(() {
// 		if (trimmed.isEmpty) return;
// 		final trimmed = text.trim();
// 	void _addItem(String text) {

// 	final List<TodoItem> _items = [];
// 	final TextEditingController _controller = TextEditingController();
// class _TodoPageState extends State<TodoPage> {

// }
// 	State<TodoPage> createState() => _TodoPageState();
// 	@override
// 	const TodoPage({super.key});
// class TodoPage extends StatefulWidget {

// }
// 	});
// 		this.done = false,
// 		required this.title,
// 		required this.id,
// 	TodoItem({

// 	bool done;
// 	String title;
// 	final String id;
// class TodoItem {

// }
// 	}
// 		);
// 			home: const TodoPage(),
// 			theme: ThemeData(primarySwatch: Colors.indigo),
// 			title: 'Todo List',
// 		return MaterialApp(
// 	Widget build(BuildContext context) {
// 	@override
// 	const MyApp({super.key});
// class MyApp extends StatelessWidget {

// void main() => runApp(const MyApp());
// import 'package:flutter/material.dart';

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
