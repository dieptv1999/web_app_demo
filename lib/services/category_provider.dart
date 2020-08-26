import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_app_demo/model/category_model.dart';

class CategoryProvider {
  Future<List<CategoryModel>> getCategory() async {
    List<CategoryModel> response = new List();
    List col = await FirebaseFirestore.instance
        .collection('category')
        .get()
        .then((val) {
      return val.docs;
    });
    for (int i = 0; i < col.length; i++) {
      await FirebaseFirestore.instance
          .collection("category")
          .doc(col[i].documentID.toString())
          .get()
          .then((value) {
        response.add(CategoryModel.fromJson(value.data()));
      });
    }
    return response;
  }

  Future<List<String>> getListCategoryName() async {
    List<String> response = new List();
    List col = await FirebaseFirestore.instance
        .collection('category')
        .get()
        .then((val) {
      return val.docs;
    });
    response = col.map((e) => e.documentID.toString()).toList();
    return response;
  }

  Future<CategoryModel> getCategoryById(String id) async {
    CategoryModel response;
    await FirebaseFirestore.instance
        .collection("category")
        .doc(id)
        .get()
        .then((value) {
      response = CategoryModel.fromJson(value.data());
    });
    return response;
  }

  Future removePost(String idCate, String idPost) async {
    CategoryModel model = await getCategoryById(idCate);
    model.posts.remove(idPost);
    await FirebaseFirestore.instance
        .collection("category")
        .doc(idCate)
        .update(model.toMap());
  }
  Future addPost(String idCate, String idPost) async {
    CategoryModel model = await getCategoryById(idCate);
    model.posts.add(idPost);
    await FirebaseFirestore.instance
        .collection("category")
        .doc(idCate)
        .update(model.toMap());
  }
}
