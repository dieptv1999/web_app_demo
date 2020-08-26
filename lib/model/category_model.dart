class CategoryModel {
  String id;
  String tag;
  String image;
  List<String> posts;

  CategoryModel({
    this.id,
    this.tag,
    this.image,
    this.posts,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      tag: json['tag'],
      image: json['image'],
      posts: json['posts'].cast<String>(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'tag': this.tag,
      'image': this.image,
      'posts': this.posts,
    };
  }
}
