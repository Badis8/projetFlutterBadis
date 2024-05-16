import 'package:flutter/material.dart';
import 'package:task_management_project/services/CategoryService.dart';

import 'Catregory.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> _categoryList = [];
  CategoryService cs = CategoryService();

  List<Category> get categoryList => _categoryList;

  Future<void> getAllCat(String id) async {
    _categoryList = [];
    var categories = await cs.readCategoriesByUserId(id);

    categories.forEach((category) {
      var categoryModel = Category();
      categoryModel.name = category.name;
      categoryModel.description = category.description;
      categoryModel.userID = id;
      categoryModel.id=category.id;

      _categoryList.add(categoryModel);
    });

    notifyListeners();
  }
  Future<void> initialize(String id) async {
    _categoryList = [];
    var categories = await cs.readCategoriesByUserId(id);

    categories.forEach((category) {
      var categoryModel = Category();
      categoryModel.name = category.name;
      categoryModel.description = category.description;
      categoryModel.userID = id;
      categoryModel.id=category.id;
      _categoryList.add(categoryModel);
    });

    notifyListeners();
  }
  Future<void> saveCategory(Category cat, String id) async {
    cat.id=await cs.saveCategory(cat, id);
    cat.userID=id;
     _categoryList.add(cat);
    notifyListeners();
  }
  Future<void> update(Category cat) async {

    await cs.update(cat);
    Category originalCat = _categoryList.firstWhere((cat) => cat.id == cat.id);
    int index = _categoryList.indexOf(originalCat);
    _categoryList[index] = cat;
    print(index);
    notifyListeners();
  }

  Future<void>  delete(String categoryID) async{
    await cs.deleteByid(categoryID);
    _categoryList.removeWhere((category) => category.id == categoryID);
    notifyListeners();
  }

  List<DropdownMenuItem> toCategories() {
    List<DropdownMenuItem> result=[];
    _categoryList.forEach((element) {
      result.add(DropdownMenuItem(value:element.name, child: Text(element.name)));
    });
    return result;
  }
  @override
  void dispose() {

  }
}