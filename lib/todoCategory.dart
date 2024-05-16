import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_project/helpers/drawerNavigation.dart';
import 'package:task_management_project/todo.dart';

import 'models/task.dart';
import 'models/taskProvider.dart';
class todoCategory extends StatefulWidget {
  final String category;

  const todoCategory({super.key, required this.category});


  @override
  State<todoCategory> createState() => _todoCategory();
}


class _todoCategory extends State<todoCategory> {
  late taskProvider  providerTask;
  _showEditFormDialog(BuildContext context, Task task) {
    final TextEditingController _titleController = TextEditingController(text: task.title);
    final TextEditingController _descriptionController = TextEditingController(text: task.description);
    final TextEditingController _dateController = TextEditingController(text: task.date);

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () async {
                  task.title = _titleController.text;
                  task.description = _descriptionController.text;
                  task.date = _dateController.text;
                  await providerTask.update(task);
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
            title: const Text("Edit Task Form"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                        hintText: "Edit task title",
                        labelText: "Title"
                    ),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        hintText: "Edit task description",
                        labelText: "Description"
                    ),
                  ),
                  TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                        hintText: "Edit task date",
                        labelText: "Date"
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }



  @override
  void initState(){
    super.initState();
    providerTask= Provider.of<taskProvider>(context, listen: false);
    final User? user = FirebaseAuth.instance.currentUser;
    String? id=user?.uid;
    providerTask.initialize(id!);
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
          title:   Text('tasks for '+this.widget.category),

          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("login", (route) => false);
                },
                icon: Icon(Icons.exit_to_app))
          ],
        ),

        drawer:DrawerNavigation(),

        body:  Consumer<taskProvider>(builder: (context,providerTask,child){
          return  ListView.builder(itemCount:providerTask.getListCategory(this.widget.category).length,itemBuilder: (context,index){
            return Dismissible(
                key: UniqueKey(),
            onDismissed: (direction) {
            providerTask.delete(providerTask.tasksList[index].id);
            },
            background: Container(
            color: Colors.red,
            child: const Align(
            alignment: Alignment.centerRight,
            child: Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
            Icons.delete,
            color: Colors.white,
            ),
            ),
            ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top:8.0,left:8.0,right:8.0),
              child: Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),

                  child:ListTile(
                    leading: Checkbox(
                      value: providerTask.getListCategory(this.widget.category)[index].isFinished,
                      onChanged: (value) {
                        setState(() {
                          providerTask.getListCategory(this.widget.category)[index].isFinished = value!;
                          providerTask.update(providerTask.getListCategory(this.widget.category)[index]);
                        });
                      },
                    ),
                    title:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(providerTask.getListCategory(this.widget.category)[index].title)
                      ],
                    ),
                    subtitle: Text(providerTask.getListCategory(this.widget.category)[index].description+"\n"+providerTask.getListCategory(this.widget.category)[index].date),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditFormDialog(context, providerTask.getListCategory(this.widget.category)[index]);
                          },
                        ),
                      ],
                    ),


                  )
              ),
            ));

          });
        }));
  }
}
