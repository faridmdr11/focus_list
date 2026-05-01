import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Provider - Central brain for all app state
class TaskProvider extends ChangeNotifier {
  /// DATA
  final List<Map<String, dynamic>> _todos = [];
  String _filter = "all";
  bool _isDarkMode = false;
  late Box _tasksBox;

  /// PENDING TIMERS - Tasks checked but waiting 2s before moving to completed
  final Map<Map<String, dynamic>, Timer> _pendingTimers = {};

  /// GETTERS
  List<Map<String, dynamic>> get allTodos => List.unmodifiable(_todos);

  String get filter => _filter;
  bool get isDarkMode => _isDarkMode;

  /// Active items: done=false OR pending timer exists
  List<MapEntry<int, Map<String, dynamic>>> get activeItems {
    return _todos.asMap().entries.where((e) {
      return e.value["done"] != true || _pendingTimers.containsKey(e.value);
    }).toList();
  }

  /// Completed items: done=true AND no pending timer
  List<MapEntry<int, Map<String, dynamic>>> get completedItems {
    return _todos.asMap().entries.where((e) {
      return e.value["done"] == true && !_pendingTimers.containsKey(e.value);
    }).toList();
  }

  /// Check if task is pending (checked but timer running)
  bool isPending(int index) => _pendingTimers.containsKey(_todos[index]);

  /// INIT - Load from Hive
  void init(Box box) {
    _tasksBox = box;
    final tasks = box.values.map((e) => Map<String, dynamic>.from(e)).toList();
    _todos.addAll(tasks.reversed);
    notifyListeners();
  }

  /// SAVE to Hive
  void _saveTasks() {
    _tasksBox.clear();
    for (final task in _todos.reversed) {
      _tasksBox.add(task);
    }
  }

  /// ADD TASK
  void addTask(String text) {
    if (text.trim().isEmpty) return;
    final newTask = {"text": text.trim(), "done": false};
    _todos.insert(0, newTask);
    _tasksBox.add(newTask);
    notifyListeners();
  }

  /// DELETE TASK
  void deleteTask(int index) {
    final task = _todos[index];
    _pendingTimers[task]?.cancel();
    _pendingTimers.remove(task);
    _todos.removeAt(index);
    _saveTasks();
    notifyListeners();
  }

  /// UNDO DELETE
  void undoDelete(Map<String, dynamic> task) {
    _todos.insert(0, task);
    _saveTasks();
    notifyListeners();
  }

  /// TOGGLE DONE - With 2-second delay before moving to completed
  void toggleDone(int index) {
    final task = _todos[index];
    if (task["done"] == true) {
      // UNCHECK - Cancel pending timer if exists
      _pendingTimers[task]?.cancel();
      _pendingTimers.remove(task);
      task["done"] = false;
      _saveTasks();
      notifyListeners();
    } else {
      // CHECK - Mark done, start 2s timer
      task["done"] = true;
      notifyListeners(); // Immediate UI update (shows checked)

      _pendingTimers[task] = Timer(Duration(seconds: 2), () {
        _pendingTimers.remove(task);
        _saveTasks();
        notifyListeners(); // Now moves to COMPLETED section
      });
    }
  }

  /// DELETE ALL COMPLETED
  void deleteAllCompleted() {
    _todos.removeWhere((t) => t["done"] == true);
    _saveTasks();
    notifyListeners();
  }

  /// EDIT TASK
  void editTask(int index, String text) {
    if (text.trim().isEmpty) return;
    final task = _todos[index];
    _pendingTimers[task]?.cancel();
    _pendingTimers.remove(task);
    _todos[index]["text"] = text.trim();
    _saveTasks();
    notifyListeners();
  }

  /// SET FILTER
  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }

  /// TOGGLE THEME
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  @override
  void dispose() {
    for (final timer in _pendingTimers.values) {
      timer.cancel();
    }
    _pendingTimers.clear();
    super.dispose();
  }
}
