class PostModel {
  String id;
  String content;
  String createAt;
  String recentVisit;
  String subContent;
  String title;
  String topicPhoto;
  String tag;
  int view;

  PostModel({
    this.id,
    this.content,
    this.createAt,
    this.recentVisit,
    this.subContent,
    this.title,
    this.topicPhoto,
    this.tag,
    this.view,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      content: json['content'],
      title: json['title'],
      createAt: json['createAt'],
      recentVisit: json['recentVisit'],
      subContent: json['subContent'],
      topicPhoto: json['topicPhoto'],
      tag: json['tag'],
      view: json['view'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'content': this.content,
      'title': this.title,
      'createAt': this.createAt,
      'recentVisit': this.recentVisit,
      'subContent': this.subContent,
      'topicPhoto': this.topicPhoto,
      'tag': this.tag,
      'view': this.view,
    };
  }
}
