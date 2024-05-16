import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'Home.dart';
import 'models/taskProvider.dart';
import 'models/providerCategory.dart';
import 'models/task.dart';
class todo extends StatefulWidget {
  @override _todo createState() => _todo();
}

class _todo extends State<todo> {
  var todoTitleController = TextEditingController();
  var todoDescriptionController = TextEditingController();
  var todoDateController = TextEditingController();
  var _categories;
  var _selected;
  late taskProvider  providerTask;
  late CategoryProvider  provider;
  @override
  void initState(){
    super.initState();
    provider = Provider.of<CategoryProvider>(context, listen: false);
    providerTask= Provider.of<taskProvider>(context, listen: false);

  }


  DateTime _dateTime=DateTime.now();
  _selectedTodoDate(BuildContext context)async{
    var _pickedDate=await showDatePicker(context: context, firstDate: _dateTime, lastDate: DateTime(2100));
    if(_pickedDate!=null){
      setState(() {
        _dateTime=_pickedDate;
        todoDateController.text=DateFormat("yyyy-MM-DD").format(_pickedDate);
      });
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("create Todo"),
      ),
      body: Consumer<CategoryProvider>(builder: (context,provider,child){return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: todoTitleController,
              decoration: InputDecoration(
                labelText: "Title",
                hintText: "Write todo Title",
              ),
            ),
            TextField(
              controller: todoDescriptionController,
              decoration: InputDecoration(
                  labelText: "Description",
                  hintText: "Write todo description"),
            ),
            TextField(
              controller: todoDateController,
              decoration: InputDecoration(
                  labelText: "todo date",
                  hintText: "Write todo date",
                  prefixIcon: InkWell(
                    onTap: () {
                      _selectedTodoDate(context);
                    },
                    child: Icon(Icons.calendar_today),
                  )),
            ),
            DropdownButtonFormField(
                items: provider.toCategories(), value: _selected, hint: Text("category") ,onChanged: (value){
              setState(() {
                _selected = value;
              });
            }),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async{
                print("pressed");
                Task t=Task();
                final User? user = FirebaseAuth.instance.currentUser;
                String? id=user?.uid;
                t.userID=id!;
                t.title=todoTitleController.text;
                t.date=todoDateController.text;
                t.CategoryName=_selected.toString();
                t.description=todoDescriptionController.text;
                t.isFinished=false;
                await providerTask.saveCategory(t);
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Homepage()));

              },

              child: Text('save'),
            ),
          ],
        ),
      );
      }),
    );
  }
}