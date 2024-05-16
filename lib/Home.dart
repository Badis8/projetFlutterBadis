import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_project/helpers/drawerNavigation.dart';
import 'package:task_management_project/todo.dart';

import 'models/task.dart';
import 'models/taskProvider.dart';
class Homepage extends StatefulWidget {


  const Homepage({super.key});


  @override
  State<Homepage> createState() => _HomepageState();
}


class _HomepageState extends State<Homepage> {

  late taskProvider  providerTask;
  @override
  void initState(){
    super.initState();
    providerTask= Provider.of<taskProvider>(context, listen: false);
    final User? user = FirebaseAuth.instance.currentUser;
    String? id=user?.uid;
    providerTask.initialize(id!);

  }


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
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text('general list task'),

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
        floatingActionButton: FloatingActionButton(onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>todo())),child:Icon(Icons.add)),
        body:  Consumer<taskProvider>(builder: (context,providerTask,child){
    return  ListView.builder(itemCount:providerTask.tasksList.length,itemBuilder: (context,index){
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
        value: providerTask.tasksList[index].isFinished,
        onChanged: (value) {
          setState(() {
            providerTask.tasksList[index].isFinished = value!;
            providerTask.update(providerTask.tasksList[index]);
          });
        },
      ),
      title:Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
      Text(providerTask.tasksList[index].title)
      ],
      ),
      subtitle: Text(providerTask.tasksList[index].description+"\n"+providerTask.tasksList[index].date),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _showEditFormDialog(context, providerTask.tasksList[index]);
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
