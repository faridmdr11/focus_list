import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';

/// ENTRY POINT
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('tasksBox');
  runApp(FocusListApp());
}

/// APP ROOT
class FocusListApp extends StatelessWidget {
  const FocusListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final provider = TaskProvider();
        provider.init(Hive.box('tasksBox'));
        return provider;
      },
      child: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'Focus List',
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.indigo,
            ),
            themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: TodoListScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

/// List item type for grouped display
class _ListItem {
  final bool isHeader;
  final String? headerText;
  final int? originalIndex;
  _ListItem.header(this.headerText) : isHeader = true, originalIndex = null;
  _ListItem.task(this.originalIndex) : isHeader = false, headerText = null;
}

/// MAIN SCREEN
class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  /// Build flat list with headers and tasks
  List<_ListItem> _buildItems(TaskProvider provider) {
    final items = <_ListItem>[];

    if (provider.filter == 'all' || provider.filter == 'active') {
      final active = provider.activeItems;
      if (provider.filter == 'all' && active.isNotEmpty) {
        items.add(_ListItem.header('ACTIVE'));
      }
      for (final entry in active) {
        items.add(_ListItem.task(entry.key));
      }
    }

    if (provider.filter == 'all' || provider.filter == 'done') {
      final completed = provider.completedItems;
      if (provider.filter == 'all' && completed.isNotEmpty) {
        items.add(_ListItem.header('COMPLETED'));
      }
      for (final entry in completed) {
        items.add(_ListItem.task(entry.key));
      }
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final items = _buildItems(provider);
    final hasCompleted = provider.completedItems.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text('Focus List'),
        actions: [
          /// DELETE ALL COMPLETED
          if (hasCompleted)
            IconButton(
              icon: Icon(Icons.delete_sweep),
              tooltip: 'Clear completed',
              onPressed: () => _confirmDeleteAllCompleted(context, provider),
            ),
          /// THEME TOGGLE
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.wb_sunny
                  : Icons.nightlight_round,
            ),
            onPressed: () => provider.toggleTheme(),
          ),
        ],
      ),
      body: Column(
        children: [
          /// FILTER CHIPS
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFilterChip('All', 'all', provider),
                SizedBox(width: 8),
                _buildFilterChip('Active', 'active', provider),
                SizedBox(width: 8),
                _buildFilterChip('Done', 'done', provider),
              ],
            ),
          ),
          /// TASK LIST
          Expanded(
            child: items.isEmpty
                ? Center(child: Text('No tasks yet!'))
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      if (item.isHeader) {
                        return _buildSectionHeader(item.headerText!);
                      }
                      final originalIndex = item.originalIndex!;
                      final task = provider.allTodos[originalIndex];
                      final isPending = provider.isPending(originalIndex);
                      return _buildTaskTile(context, provider, task, originalIndex, isPending);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, provider),
        tooltip: 'Add task',
        child: Icon(Icons.add),
      ),
    );
  }

  /// SECTION HEADER WIDGET
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  /// TASK TILE with checkbox and swipe-to-delete
  Widget _buildTaskTile(BuildContext context, TaskProvider provider,
      Map<String, dynamic> task, int originalIndex, bool isPending) {
    final isDone = task["done"] == true;

    return Dismissible(
      key: Key(task["text"]! + originalIndex.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        final deleted = Map<String, dynamic>.from(task);
        provider.deleteTask(originalIndex);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deleted "${deleted["text"]}"'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () => provider.undoDelete(deleted),
            ),
          ),
        );
        return true;
      },
      child: ListTile(
        leading: Checkbox(
          value: isDone,
          onChanged: (_) => provider.toggleDone(originalIndex),
        ),
        title: Text(
          task["text"]!,
          style: TextStyle(
            decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
            color: isDone ? Colors.grey : null,
            fontStyle: isPending ? FontStyle.italic : FontStyle.normal,
          ),
        ),
        subtitle: isPending
            ? Text('Moving to completed...', style: TextStyle(fontSize: 11, color: Colors.orange))
            : null,
        trailing: isPending
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : null,
        onTap: () => _showEditDialog(context, provider, originalIndex),
      ),
    );
  }

  /// FILTER CHIP helper
  Widget _buildFilterChip(String label, String filter, TaskProvider provider) {
    return ChoiceChip(
      label: Text(label),
      selected: provider.filter == filter,
      onSelected: (_) => provider.setFilter(filter),
    );
  }

  /// CONFIRM DELETE ALL COMPLETED
  void _confirmDeleteAllCompleted(BuildContext context, TaskProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Completed?'),
        content: Text('This will delete all completed tasks permanently.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteAllCompleted();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('All completed tasks deleted')),
              );
            },
            child: Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// ADD DIALOG with [Cancel] [Add More] [Add]
  void _showAddDialog(BuildContext context, TaskProvider provider) {
    final controller = TextEditingController();
    final focusNode = FocusNode();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return CallbackShortcuts(
            bindings: {
              SingleActivator(LogicalKeyboardKey.enter, shift: true): () {
                provider.addTask(controller.text);
                controller.clear();
                focusNode.requestFocus();
              },
            },
            child: AlertDialog(
              title: Text('Add New Task'),
              content: TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Type your task...',
                  helperText: 'Shift+Enter to add more',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    provider.addTask(controller.text);
                    controller.clear();
                    focusNode.requestFocus();
                  },
                  child: Text('Add More'),
                ),
                ElevatedButton(
                  onPressed: () {
                    provider.addTask(controller.text);
                    Navigator.pop(context);
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// EDIT DIALOG
  void _showEditDialog(BuildContext context, TaskProvider provider, int index) {
    final controller = TextEditingController(text: provider.allTodos[index]["text"]);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Task'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: 'Update task...'),
          onSubmitted: (_) {
            provider.editTask(index, controller.text);
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.editTask(index, controller.text);
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
