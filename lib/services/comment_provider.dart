import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_app_demo/model/comment_model.dart';

class CommentProvider {
  Future<CommentModel> getComment(String id) async {
    CommentModel response;
    await FirebaseFirestore.instance
        .collection("comments")
        .doc(id)
        .get()
        .then((value) {
      response = CommentModel.fromJson(value.data());
    });
    return response;
  }

  Future addComment(String id, String content) async {
    CommentModel model = await getComment(id);
    model.content.add(content);
    await FirebaseFirestore.instance
        .collection("comments")
        .doc(id)
        .update(model.toMap());
  }
}
