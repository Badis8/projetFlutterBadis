import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Catregory.dart';

class CategoryService{

  Future<String> saveCategory(Category cat, String id) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference categories = firestore.collection('categories');

    DocumentReference docRef =await categories.add({
      'userid':id,
      'name': cat.name,
      'description': cat.description,
    });
   return docRef.id;
  }


  Future<List<Category>> readCategoriesByUserId(String userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore.collection('categories').where('userid', isEqualTo: userId).get();

    List<Category> categories = [];

    for (DocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
      if (doc.exists) {
        Map<String, dynamic> data = doc.data()!;
        Category category = Category();
        category.userID = data['userid'];
        category.name = data['name'];
        category.description = data['description'];
        category.id=doc.id;
        categories.add(category);
      }
    }
  print("here");

    return categories;
  }

  Future<Category> readCategory(String id) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentSnapshot<Map<String, dynamic>> doc =
    await firestore.collection('categories').doc(id).get();

    if (doc.exists) {
      final Map<String, dynamic> data = doc.data()!;
      Category category = Category();
      category.id= doc.id;
     category.userID= data['userid'];
    category.name= data['name'];
    category.description= data['description'];

      return category;
    } else {
      throw Exception('Category document not found');
    }
  }




  Future<void> update(Category cat) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference<Map<String, dynamic>> categories =
    firestore.collection('categories');
    final DocumentReference<Map<String, dynamic>> docRef =
    categories.doc(cat.id);

    await docRef.update({
      'userid': cat.userID,
      'name': cat.name,
      'description': cat.description,
    });
  }

  Future<void>  deleteByid(String categoryID) async{
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference<Map<String, dynamic>> categories =
    firestore.collection('categories');
    final DocumentReference<Map<String, dynamic>> docRef =
    categories.doc(categoryID);

    await docRef.delete();
  }

  Future<List<Category>> readCategoriesByUserIdAndCategory(String userId,category) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore.collection('categories').where('userid', isEqualTo: userId).where('category', isEqualTo: category).get();

    List<Category> categories = [];

    for (DocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
      if (doc.exists) {
        Map<String, dynamic> data = doc.data()!;
        Category category = Category();
        category.userID = data['userid'];
        category.name = data['name'];
        category.description = data['description'];
        category.id=doc.id;
        categories.add(category);
      }
    }


    return categories;
  }

}