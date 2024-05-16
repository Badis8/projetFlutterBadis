
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task.dart';
import '../models/task.dart';


class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    late CollectionReference _tasksCollection ;
  TaskService(){
    _tasksCollection=_firestore.collection('tasks');
  }
  Future<String> saveTask(Task task) async {
    final DocumentReference docRef  =
    await _tasksCollection.add({
      'userid':task.userID,
      'name': task.title,
      'description': task.description,
      'date':task.date,
      'category':task.CategoryName,
      'isFinished':task.isFinished
    });
    return docRef.id;
  }


  Future<List<Task>> readTasksByuserId(String userid) async {

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('tasks').where('userid', isEqualTo: userid).get();

    List<Task> tasks = [];

    for (DocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
      if (doc.exists) {
        Map<String, dynamic> data = doc.data()!;
        Task task = Task();
        task.userID = data['userid'];
        task.title = data['name'];
        task.description = data['description'];
        task.id = doc.id;
        task.CategoryName=data['category'];
        task.date=data['date'];
        task.isFinished=data['isFinished'];
        tasks.add(task);
      }
    }


    return tasks;
  }

  Future<Task> readTask(String taskId) async {

    final DocumentSnapshot<Map<String, dynamic>> doc =
    await _firestore.collection('tasks').doc(taskId).get();

    if (doc.exists) {
      final Map<String, dynamic> data = doc.data()!;
      Task task = Task();
      task.userID = data['userid'];
      task.title = data['name'];
      task.description = data['description'];
      task.id = doc.id;
      task.CategoryName=data['category'];
      task.date=data['date'];
      task.isFinished=data['isFinished'];
      return task;
    } else {
      throw Exception('Category document not found');
    }
  }

  Future<void> deleteTask(String taskId) async {
    final CollectionReference<Map<String, dynamic>> tasks =
    _firestore.collection('tasks');
    final DocumentReference<Map<String, dynamic>> docRef =
    tasks.doc(taskId);
    await docRef.delete();
  }


  Future<void> update(Task task) async {

    final CollectionReference<Map<String, dynamic>> categories =
    _firestore.collection('tasks');
    final DocumentReference<Map<String, dynamic>> docRef =
    categories.doc(task.id);

    await docRef.update({
      'userid':task.userID,
      'name': task.title,
      'description': task.description,
      'date':task.date,
      'category':task.CategoryName,
      'isFinished':task.isFinished

    });
  }
}