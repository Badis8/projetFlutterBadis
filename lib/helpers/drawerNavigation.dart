import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_management_project/services/CategoryService.dart';

import '../Categories.dart';
import '../Home.dart';
import '../todoCategory.dart';
class DrawerNavigation extends StatefulWidget {





  @override _DrawerNavigationState createState() => _DrawerNavigationState();

}
class _DrawerNavigationState extends State<DrawerNavigation> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getallCategories();

  }
  CategoryService cs=CategoryService();
  List<Widget>_categoryList=[];
  getallCategories()async{

    final User? user = FirebaseAuth.instance.currentUser;
    String? id=user?.uid;
    var categories=await cs.readCategoriesByUserId(id!);
    categories.forEach((c) {
    setState(() {
      _categoryList.add(InkWell(
        onTap: ()=>Navigator.push(context,new MaterialPageRoute(builder: (context)=>new todoCategory(category:c.name ) )),
        child: ListTile(
          title:Text(c.name),
        ),
      ));
    });
    });
  }
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    final String? userName = user?.displayName;
    final String? userEmail = user?.email;

    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(  accountName: Text(userName ?? "Unknown"),
              accountEmail: Text(userEmail ?? "Unknown"),),
            ListTile(
              leading: Icon(Icons.home),
              title:Text('home'),
              onTap:()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Homepage())),
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title:Text('categories'),
              onTap:()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Categories())),
            ),
            Divider(),
            Column(
              children:_categoryList,
            )

          ],


        ),
      ),
    );
  }
}
