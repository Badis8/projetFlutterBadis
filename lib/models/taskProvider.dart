import 'package:flutter/material.dart';
import 'package:task_management_project/services/CategoryService.dart';
import '../models/task.dart';
import '../services/taskService.dart';
import 'Catregory.dart';

class taskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  TaskService cs = TaskService();

  List<Task> get tasksList => _tasks;

  Future<void> getAllTasks(String id) async {
    _tasks = [];
    var tasks = await cs.readTasksByuserId(id);

    tasks.forEach((t) {
      Task task = Task();
      task.title = t.title;
      task.description = t.description;
      task.userID = t.userID;
      task.id=t.id;
      task.date=t.date;
      task.CategoryName=t.CategoryName;
      task.isFinished=t.isFinished;
      _tasks.add(task);
    });

    notifyListeners();
  }
  Future<void> initialize(String id) async {
    _tasks = [];
    var tasks = await cs.readTasksByuserId(id);

    tasks.forEach((t) {
      Task task = Task();
      task.title = t.title;
      task.description = t.description;
      task.userID = t.userID;
      task.id=t.id;
      task.date=t.date;
      task.CategoryName=t.CategoryName;
      task.isFinished=t.isFinished;
      _tasks.add(task);
    });

    notifyListeners();
  }
  Future<void> saveCategory(Task task ) async {
  task.id=await cs.saveTask(task);
  _tasks.add(task);
    notifyListeners();
  }
  Future<void> update(Task task) async {

    await cs.update(task);
    Task originalCat = _tasks.firstWhere((t) => task.id == t.id);
    int index = _tasks.indexOf(originalCat);
    _tasks[index] = task;

    notifyListeners();
  }

  Future<void>  delete(String taskid) async{
    await cs.deleteTask(taskid);
    _tasks.removeWhere((t) => t.id == taskid);
    notifyListeners();
  }

  List<Task> get completedTasks => _tasks.where((task) => task.isFinished == 1).toList();

  List<Task> get uncompletedTasks => _tasks.where((task) => task.isFinished == 0).toList();

  List<Task> getListCategory(String category) {
    return _tasks.where((task) => task.CategoryName == category).toList();
  }
  @override
  void dispose() {

  }

}