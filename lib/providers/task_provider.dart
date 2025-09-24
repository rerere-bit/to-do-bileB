import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  String _filter = 'All'; // All, Active, Done

  List<Task> get tasks {
    switch (_filter) {
      case 'Active':
        return _tasks.where((t) => !t.isDone).toList();
      case 'Done':
        return _tasks.where((t) => t.isDone).toList();
      default:
        return _tasks;
    }
  }

  int get activeCount => _tasks.where((t) => !t.isDone).length;

  void addTask(String title) {
    _tasks.add(Task(title: title));
    notifyListeners();
  }

  void toggleTask(Task task) {
    task.isDone = !task.isDone;
    notifyListeners();
  }

  void removeTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }
}
