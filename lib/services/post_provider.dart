import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_app_demo/model/post_model.dart';

class PostProvider {
  Future<PostModel> getPost(String id) async {
    PostModel response;
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(id)
        .get()
        .then((val) {
      //print(val.data()['content']);
      response = PostModel.fromJson(val.data());
    });
    return response;
  }

  Future<bool> setPost(PostModel post) async {
    bool response = false;
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(post.id)
        .set(post.toMap())
        .then((value) {
      response = true;
    }).timeout(Duration(seconds: 10));
    return response;
  }

  Future<bool> updatePost(PostModel post) async {
    bool response = false;
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(post.id)
        .update(post.toMap())
        .then((value) {
      response = true;
    }).timeout(Duration(seconds: 10));
    return response;
  }

  Future<List<PostModel>> getAllPost() async {
    List col =
        await FirebaseFirestore.instance.collection('posts').get().then((val) {
      return val.docs;
    });
    List<PostModel> response = new List();
    for (int i = 0; i < col.length; i++) {
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(col[i].documentID.toString())
          .get()
          .then((value) {
        response.add(PostModel.fromJson(value.data()));
      });
    }
    return response;
  }

  Future<List<String>> getAllPostName() async {
    List col =
        await FirebaseFirestore.instance.collection('posts').get().then((val) {
      return val.docs;
    });
    List<String> response = new List();
    for (int i = 0; i < col.length; i++) {
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(col[i].documentID.toString())
          .get()
          .then((value) {
        response.add(value.data()['title'].toString());
      });
    }
    return response;
  }

  Future<List<PostModel>> getListPostById(List<String> posts) async {
    if (posts == null || posts.length < 1) return new List();
    List<PostModel> response = new List();
    for (int i = 0; i < posts.length; i++) {
      if (posts[i] != "")
        await FirebaseFirestore.instance
            .collection("posts")
            .doc(posts[i])
            .get()
            .then((value) {
          response.add(PostModel.fromJson(value.data()));
        });
    }
    return response;
  }

  Future<List<String>> getListPostNameById(List<String> posts) async {
    if (posts == null || posts.length < 1) return new List();
    List<String> response = new List();
    for (int i = 0; i < posts.length; i++) {
      if (posts[i] != "")
        await FirebaseFirestore.instance
            .collection("posts")
            .doc(posts[i])
            .get()
            .then((value) {
          response.add(value.data()['title'].toString());
        });
    }
    return response;
  }
}
