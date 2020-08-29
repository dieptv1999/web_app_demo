import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentWidget extends StatefulWidget {
  double height;
  double width;

  CommentWidget({
    this.height,
    this.width,
  });

  @override
  State<StatefulWidget> createState() => CommentState();
}

class CommentState extends State<CommentWidget>
    with SingleTickerProviderStateMixin {
  double height;
  double width;

  CommentState({
    this.height,
    this.width,
  });

  Color _write = Colors.blueAccent;
  Color _preview = Colors.black38;
  int _idx = 0;
  TabController _tabController;
  String content = '';
  TextEditingController _editController;
  TextEditingController _previewController;

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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 150,
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
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
              child: ButtonBar(
                buttonPadding: EdgeInsets.zero,
                children: [
                  FlatButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _onBold();
                    },
                    child: Container(
                      height: 24,
                      width: 24,
                      child: Image.asset(
                        'assets/editor/004-bold.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  FlatButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    child: Container(
                      height: 24,
                      width: 24,
                      child: Image.asset(
                        'assets/editor/031-italic.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  FlatButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    child: Container(
                      height: 24,
                      width: 24,
                      child: Image.asset(
                        'assets/editor/057-underline.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  FlatButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    child: Container(
                      height: 24,
                      width: 24,
                      child: Image.asset(
                        'assets/editor/005-quote.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  FlatButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    child: Container(
                      height: 24,
                      width: 24,
                      child: Image.asset(
                        'assets/editor/009-code.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  FlatButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    child: Container(
                      height: 24,
                      width: 24,
                      child: Image.asset(
                        'assets/editor/034-link.png',
                        fit: BoxFit.fill,
                      ),
                    ),
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
                ),
                TextField(
                  controller: _previewController,
                  maxLines: 10,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(8),
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
                style: TextStyle(color: Colors.black38),
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
                      child: Text('Delete All'),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {},
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Save comment',
                        style: TextStyle(color: Colors.white),
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
