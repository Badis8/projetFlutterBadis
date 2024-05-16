import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_management_project/services/CategoryService.dart';
import 'package:provider/provider.dart';
import 'Home.dart';
import 'models/Catregory.dart';
import 'models/providerCategory.dart';
class Categories extends StatefulWidget {
  @override _Categories createState() => _Categories();
}
class _Categories extends State<Categories> {
  final TextEditingController categories = TextEditingController();
  final TextEditingController description = TextEditingController();

  final TextEditingController editcategories = TextEditingController();
  final TextEditingController editdescription = TextEditingController();
  late Category category;
  List<Category> _categoryList=[];
  late CategoryProvider  provider;
  @override
  void initState(){
    super.initState();
    final User? user = FirebaseAuth.instance.currentUser;
    String? id=user?.uid;
    provider = Provider.of<CategoryProvider>(context, listen: false);
    getAllCat(id!);
    provider.initialize(id);
  }




  getAllCat(String id) async{
    _categoryList=[];
    var categories=await cs.readCategoriesByUserId(id);

    categories.forEach((category){
      setState(() {
        var categoryModel=Category();
        categoryModel.name=category.name;
            categoryModel.description=category.description;
            categoryModel.userID=id;
        _categoryList.add(categoryModel);
      });
    });

  }
  editCategory(BuildContext context,categoryID)async{
    category=await cs.readCategory(categoryID);
    setState(() {
      editcategories.text=category.name;
      editdescription.text=category.name;
    });
    _showEditFormDialog(context);
  }



  _deleteDialog(BuildContext context,categoryID){
    return showDialog(context:context,barrierDismissible: true,builder:(param){
      return  AlertDialog(
        actions:<Widget>[
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
            onPressed: () =>Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: ()async  {
              final User? user = FirebaseAuth.instance.currentUser;
              String? id=user?.uid;
              c.description=description.text;
              c.name=categories.text;


              await provider.delete(categoryID);
              Navigator.pop(context);

            },
            child: const Text('Delete'),
          ),
        ],
        title:const Text("are you sure ?"),

      );
    });
  }


  Category c=Category();
  CategoryService cs=CategoryService();
  _showFormDialog(BuildContext context){
    return showDialog(context:context,barrierDismissible: true,builder:(param){
      return  AlertDialog(
        actions:<Widget>[
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
            onPressed: () =>Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: ()async  {
              final User? user = FirebaseAuth.instance.currentUser;
              String? id=user?.uid;
              c.description=description.text;
              c.name=categories.text;


              await provider.saveCategory(c, id!);
              Navigator.pop(context);

            },
            child: const Text('add'),
          ),
        ],
        title:const Text("Categories Form"),
        content:   SingleChildScrollView(
          child:Column(
            children: <Widget>[
              TextField(
                controller:categories,
                decoration: InputDecoration(
                  hintText: "write a categoriy",
                  labelText: "Category"
                ),
              ),
              TextField(
                controller:description,
                decoration: InputDecoration(
                    hintText: "write a categoriy",
                    labelText: "Category"
                ),
              )
            ],
          )
        ),
      );
    });
  }


  _showEditFormDialog(BuildContext context){
    return showDialog(context:context,barrierDismissible: true,builder:(param){
      return  AlertDialog(
        actions:<Widget>[
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
            onPressed: () =>Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () async {
              final User? user = FirebaseAuth.instance.currentUser;
              String? id=user?.uid;
              c.description=editdescription.text;
              c.name=editcategories.text;
              c.id=category.id;
              c.userID=id!;
              await provider.update(c);
              Navigator.pop(context);

            },
            child: const Text('add'),
          ),
        ],
        title:const Text("edit Categories Form"),
        content:   SingleChildScrollView(
            child:Column(
              children: <Widget>[
                TextField(
                  controller:editcategories,
                  decoration: InputDecoration(
                      hintText: "edit a categoriy",
                      labelText: "Category"
                  ),
                ),
                TextField(
                  controller:editdescription,
                  decoration: InputDecoration(
                      hintText: "edit description categoriy",
                      labelText: "edit description"
                  ),
                )
              ],
            )
        ),
      );
    });
  }




  @override
  Widget build(BuildContext context) {

   return ChangeNotifierProvider(create: (context)=>provider,child:Scaffold(
   appBar: AppBar(
   leading:ElevatedButton(
       onPressed: () {
     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Homepage()));
   },
    style: ElevatedButton.styleFrom(
    primary: Colors.transparent, // make the button transparent
    elevation: 0.0, // remove the elevation shadow
    shape: CircleBorder(), // make the button a circle
    ),
    child: Icon(
    Icons.arrow_back,
    color: Colors.black, // set the icon color
    ),
    ),
    title:Text("Categories"),
    ),
    body:  Consumer<CategoryProvider>(builder: (context,provider,child){
      return  ListView.builder(itemCount:provider.categoryList.length,itemBuilder: (context,index){
    return Padding(
    padding: const EdgeInsets.only(top:8.0,left:16.0,right:16.0),

    child: Card(
    elevation: 8.0,

    child:ListTile(
    leading:IconButton(icon:Icon(Icons.edit),onPressed: (){editCategory(context,provider.categoryList[index].id);}),
    title: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children:<Widget>[
    Text(provider.categoryList[index].name),
    IconButton(onPressed: (){_deleteDialog(context,provider.categoryList[index].id);}, icon: Icon(Icons.delete))
    ]),
    subtitle: Text(provider.categoryList[index].description),
    )
    ),
    );
    });
    }),
    floatingActionButton: FloatingActionButton(onPressed: (){
    _showFormDialog(context);
    },child:Icon(Icons.add)),
    ),
   );
  }
}
