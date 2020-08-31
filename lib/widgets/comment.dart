import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:web_app_demo/model/comment_model.dart';
import 'package:web_app_demo/services/comment_provider.dart';

class CommentWidget extends StatefulWidget {
  double height;
  double width;
  String id;

  CommentWidget({
    @required this.height,
    @required this.width,
    @required this.id,
  });

  @override
  State<StatefulWidget> createState() => CommentState(
        height: height,
        width: width,
        id: id,
      );
}

class CommentState extends State<CommentWidget>
    with SingleTickerProviderStateMixin {
  double height;
  double width;
  String id;

  CommentState({
    this.height,
    this.width,
    @required this.id,
  });

  Color _write = Colors.blueAccent;
  Color _preview = Colors.black38;
  int _idx = 0;
  TabController _tabController;
  String content = '';
  TextEditingController _editController;
  TextEditingController _previewController;
  double iconSize = 24;

  @override
  void initState() {
    super.initState();
    _editController = new TextEditingController(text: content);
    _previewController = new TextEditingController();
    _tabController = new TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _idx = _tabController.index;
        if (_idx == 0) {
          _write = Colors.blueAccent;
          _preview = Colors.black38;
        } else {
          _preview = Colors.blueAccent;
          _write = Colors.black38;
        }
      });
    });
  }

  void _onBold() {
    TextSelection selected = _editController.selection;
    String s = _editController.text;
    if (selected.baseOffset != -1) {
      String x = s.substring(selected.baseOffset, selected.extentOffset);
      if (!x.startsWith('**') || !x.endsWith('**')) {
        setState(() {
          _editController.text = s.substring(0, selected.baseOffset) +
              "**" +
              x +
              "**" +
              s.substring(selected.extentOffset);
        });
      }
    } else {
      int len = _editController.text.length;
      setState(() {
        _editController.text = _editController.text + "****";
        _editController.selection = TextSelection.collapsed(
          offset: len + 2,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < 500)
      iconSize = 12;
    else
      iconSize = 24;
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 150,
              child: Padding(
                padding: EdgeInsets.only(left: 8.0, top: 3),
                child: TabBar(
                  tabs: [
                    Tab(
                      child: Text(
                        'Write',
                        style: TextStyle(
                          color: _write,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Preview',
                        style: TextStyle(
                          color: _preview,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                  controller: _tabController,
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: iconSize,
                    width: iconSize,
                    padding: EdgeInsets.zero,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        _onBold();
                      },
                      icon: Image.asset(
                        'assets/editor/004-bold.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: iconSize,
                    width: iconSize,
                    padding: EdgeInsets.zero,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        _onBold();
                      },
                      icon: Image.asset(
                        'assets/editor/031-italic.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: iconSize,
                    width: iconSize,
                    padding: EdgeInsets.zero,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        _onBold();
                      },
                      icon: Image.asset(
                        'assets/editor/057-underline.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: iconSize,
                    width: iconSize,
                    padding: EdgeInsets.zero,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        _onBold();
                      },
                      icon: Image.asset(
                        'assets/editor/005-quote.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: iconSize,
                    width: iconSize,
                    padding: EdgeInsets.zero,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        _onBold();
                      },
                      icon: Image.asset(
                        'assets/editor/009-code.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: iconSize,
                    width: iconSize,
                    padding: EdgeInsets.zero,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        _onBold();
                      },
                      icon: Image.asset(
                        'assets/editor/034-link.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          height: 196,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabBarView(
              controller: _tabController,
              children: [
                TextField(
                  controller: _editController,
                  maxLines: 10,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(8),
                  ),
                  onChanged: (text) {
                    setState(() {
                      this.content = text;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: MarkdownBody(
                      data: content,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                'Write by Markdown',
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(
              child: ButtonBar(
                //buttonPadding: EdgeInsets.all(8),
                children: [
                  FlatButton(
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Delete All',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (content != null && content != '')
                        CommentProvider().addComment(id, content);
                    },
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Save comment',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
