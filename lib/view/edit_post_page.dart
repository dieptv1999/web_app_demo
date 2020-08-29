import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web_app_demo/model/post_model.dart';
import 'package:web_app_demo/services/category_provider.dart';
import 'package:web_app_demo/services/post_provider.dart';
import 'package:web_app_demo/widgets/appbar.dart';

class EditPost extends StatefulWidget {
  static String routeName = 'EditPost';

  EditPost(this.post);

  PostModel post;

  @override
  State<StatefulWidget> createState() => EditPostState(post);
}

class EditPostState extends State<EditPost>
    with SingleTickerProviderStateMixin {
  TextEditingController _mdController;
  String text = '';
  PostModel post;

  EditPostState(this.post);

  void _save(context, PostModel post) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Thông báo'),
        content: FutureProvider<bool>(
          create: (_) => PostProvider().setPost(post),
          child: Consumer<bool>(
            builder: (_, val, __) {
              if (val != null) {
                print(val);
                if (val == true)
                  return Text('Lưu thành công');
                else
                  return Text('Lưu thất bại');
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (post == null)
      post = new PostModel(
        content: '',
        subContent: '',
        topicPhoto: '',
        title: '',
      );
    _mdController = new TextEditingController(text: post.content);
    text = post.content;
  }

  Widget _formItem(label, controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: label,
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: MyAppBar(context).getEditAppBar(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: TabBarView(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 500,
                  controller: _mdController,
                  decoration: InputDecoration(
                    hintText: 'INPUT TEXT',
                    border: InputBorder.none,
                  ),
                  onChanged: (text) {
                    setState(() {
                      this.text = text;
                    });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: MarkdownBody(
                    data: text,
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'tutorial',
              onPressed: () {},
              tooltip: 'List tags',
              child: Icon(Icons.library_books),
            ),
            SizedBox(
              height: 20,
            ),
            FloatingActionButton(
              heroTag: 'save',
              onPressed: () {
                final _formKey = GlobalKey<FormState>();
                TextEditingController _titleController =
                    new TextEditingController(text: post.title);
                TextEditingController _subContentController =
                    new TextEditingController(text: post.subContent);
                TextEditingController _topicPhotoController =
                    new TextEditingController(text: post.topicPhoto);
                TextEditingController _tagsController =
                    new TextEditingController(text: post.tag);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Container(
                          width: MediaQuery.of(context).size.width < 968
                              ? MediaQuery.of(context).size.width * 0.9
                              : MediaQuery.of(context).size.width * 0.6,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: _formItem('Title', _titleController),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: _formItem(
                                      'Sub content', _subContentController),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: _formItem(
                                      'Topic photo', _topicPhotoController),
                                ),
                                FutureProvider<List<String>>(
                                  create: (_) =>
                                      CategoryProvider().getListCategoryName(),
                                  child: Consumer<List<String>>(
                                    builder: (_, val, __) {
                                      if (val != null) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            controller: _tagsController,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              labelText: 'Tag',
                                              border: OutlineInputBorder(),
                                              suffixIcon:
                                                  PopupMenuButton<String>(
                                                icon: const Icon(
                                                    Icons.arrow_drop_down),
                                                onSelected: (String value) {
                                                  _tagsController.text =
                                                      _tagsController.text == ''
                                                          ? value
                                                          : _tagsController
                                                                  .text +
                                                              ',' +
                                                              value;
                                                },
                                                itemBuilder:
                                                    (BuildContext context) {
                                                  return val.map<
                                                          PopupMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return new PopupMenuItem(
                                                      child: new Text(value),
                                                      value: value,
                                                    );
                                                  }).toList();
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      return Center(
                                        child: LinearProgressIndicator(),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          FlatButton(
                            onPressed: () {
                              if (_topicPhotoController.text.trim() != '' &&
                                  _subContentController.text.trim() != '' &&
                                  _titleController.text.trim() != '' &&
                                  _tagsController.text.trim() != '') {
                                var bytes = utf8.encode(
                                    _titleController.text); // data being hashed
                                if (post.tag != null && post.tag != '') {
                                  List<String> tags =
                                      _tagsController.text.trim().split(',');
                                  List<String> tags2 = post.tag.split(',');
                                  tags2.forEach((element) {
                                    if (!_tagsController.text
                                        .contains(element)) {
                                      CategoryProvider()
                                          .removePost(element, post.id);
                                    }
                                  });
                                  tags.forEach((element) {
                                    if (!post.tag.contains(element)) {
                                      CategoryProvider()
                                          .addPost(element, post.id);
                                    }
                                  });
                                }
                                var digest = sha1.convert(bytes);
                                String ID = digest.toString();
                                post = new PostModel(
                                  id: ID,
                                  title: _titleController.text,
                                  view: 0,
                                  topicPhoto: _topicPhotoController.text.trim(),
                                  subContent: _subContentController.text,
                                  recentVisit: new DateFormat.yMMMd()
                                      .format(new DateTime.now()),
                                  createAt: new DateFormat.yMMMd()
                                      .format(new DateTime.now()),
                                  content: text,
                                  tag: _tagsController.text,
                                );
                                _save(context, post);
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          content: Text('Các trường còn trống'),
                                          actions: [
                                            FlatButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Đóng'),
                                            )
                                          ],
                                        ));
                              }
                            },
                            child: Text('Save'),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                        ],
                      );
                    });
              },
              tooltip: 'Save',
              child: Icon(Icons.save),
            ),
          ],
        ),
      ),
    );
  }
}
