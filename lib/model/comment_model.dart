class CommentModel {
  List<String> content;
  String createAt;
  int like;

  CommentModel({this.content, this.createAt, this.like});

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
        createAt: json['createAt'],
        like: json['like'],
        content: json['content'].cast<String>());
  }

  Map<String, dynamic> toMap() {
    return {
      'content': this.content,
      'createAt': this.createAt,
      'like': this.like,
    };
  }
}
