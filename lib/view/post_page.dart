import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:web_app_demo/model/comment_model.dart';
import 'package:web_app_demo/model/md_extension_set.dart';
import 'package:web_app_demo/model/post_model.dart';
import 'package:web_app_demo/model/screen_arg.dart';
import 'package:web_app_demo/services/comment_provider.dart';
import 'package:web_app_demo/services/post_provider.dart';
import 'package:web_app_demo/view/edit_post_page.dart';
import 'package:web_app_demo/widgets/HeadersView.dart';
import 'package:web_app_demo/widgets/appbar.dart';
import 'package:web_app_demo/widgets/comment.dart';
import 'package:web_app_demo/widgets/footer.dart';
import 'package:web_app_demo/widgets/verify_view.dart';
import 'home_page.dart';

class PostPage extends StatefulWidget {
  static String routeName = 'PostPage';
  final ScreenArg arg;

  const PostPage({Key key, this.arg}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PostPageState(arg);
}

class PostPageState extends State<PostPage> {
  final ScreenArg arg;

  PostPageState(this.arg);

  Color _likeColor = Colors.grey;

  BoxDecoration _shadowBox = BoxDecoration(
    color: Colors.white,
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.all(Radius.circular(8)),
    boxShadow: [
      BoxShadow(
        color: Color(0xff6f3d2e).withOpacity(0.4),
        offset: Offset(5, 10),
        spreadRadius: 3,
        blurRadius: 10,
      ),
      BoxShadow(
        color: Colors.white,
        offset: Offset(-3, -4),
        spreadRadius: -2,
        blurRadius: 20,
      ),
    ],
  );

  Widget _mainContent(context, sizeW, PostModel value) => Container(
      width: sizeW,
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: sizeW,
              child: Image.network(
                value.topicPhoto,
                fit: BoxFit.cover,
              )),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
            child: Text(
              value.title,
              style: TextStyle(fontSize: 40),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            value.createAt,
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 4000,
            child: Markdown(
              controller: ScrollController(),
              data: value.content.toString(),
              extensionSet: MarkdownExtensionSet.githubWeb.value,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Comment',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 26),
              ),
              _comments(value.id, sizeW),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 320,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.black38, width: 1),
            ),
            child: CommentWidget(
              height: MediaQuery.of(context).size.height * 0.3,
              width: sizeW,
              id: value.id,
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ));

  Widget _actions(context, sizeW, PostModel value) {
    return Container(
      width: sizeW,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              VerifyView().checkPermission(context, (val) {
                if (val) {
                  Navigator.pushNamed(context, EditPost.routeName,
                      arguments: value);
                } else {
                  showDialog(
                      context: context,
                      child: AlertDialog(
                        content: Text('Sai mật khẩu'),
                        actions: [
                          FlatButton(
                            child: Text('Đóng'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ));
                }
              });
            },
            child: Container(
              width: sizeW,
              height: 40,
              child: Center(
                  child: Text(
                'EDIT',
                style: TextStyle(fontSize: 20),
              )),
              decoration: _shadowBox,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {},
            child: Container(
              width: sizeW,
              height: 40,
              child: Center(
                  child: Text(
                'Table of Content',
                style: TextStyle(fontSize: 20),
              )),
              decoration: _shadowBox,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _tableOfContent(value.content, sizeW),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget _tableOfContent(String content, sizeW) {
    List<String> lines = content.split('\n');
    List<Widget> ls = new List();
    lines.forEach((element) {
      if (element.startsWith('#')) {
        int space = element.indexOf(' ');
        String header = element.substring(0, space);
        if (header.length == 1) ls.add(H1(title: element.substring(space)));
        if (header.length == 2) ls.add(H2(title: element.substring(space)));
        if (header.length == 3) ls.add(H3(title: element.substring(space)));
        if (header.length == 4) ls.add(H4(title: element.substring(space)));
      }
    });
    return Container(
      width: sizeW,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: ls,
      ),
    );
  }

  Widget _comments(id, sizeW) {
    return FutureProvider<CommentModel>(
      create: (_) => CommentProvider().getComment(id),
      child: Consumer<CommentModel>(
        builder: (_, val, __) {
          if (val != null) {
            return Container(
              height: val.content.length < 2
                  ? 200
                  : val.content.length < 4 ? 500 : 800,
              width: sizeW,
              child: ListView.builder(
                itemBuilder: (ctx, index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: MarkdownBody(
                        data: val.content.elementAt(index),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 5),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        StatefulBuilder(
                          builder: (ctx, setState) => InkWell(
                            onTap: () {
                              setState(() {
                                _likeColor = _likeColor == Colors.indigo
                                    ? Colors.grey
                                    : Colors.indigo;
                              });
                            },
                            child: Text(
                              'Thích',
                              style: TextStyle(fontSize: 10, color: _likeColor),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          '3 giờ.',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                itemCount: val.content.length,
              ),
            );
          }
          return Center();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (arg == null) Navigator.popAndPushNamed(context, MyHomePage.routeName);
    double sizeW = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: MyAppBar(context).getHomeAppBar(),
      body: LiquidPullToRefresh(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 350));
          Navigator.popAndPushNamed(
              context, PostPage.routeName + '?' + arg.post);
        },
        child: SingleChildScrollView(
          child: FutureProvider<PostModel>(
            create: (_) => PostProvider().getPost(arg.post),
            child: Consumer<PostModel>(
              builder: (_, value, __) {
                if (value != null) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      sizeW >= 968
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                _mainContent(
                                    context,
                                    MediaQuery.of(context).size.width * 0.65,
                                    value),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.03),
                                _actions(
                                    context,
                                    MediaQuery.of(context).size.width * 0.25,
                                    value),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02),
                              ],
                            )
                          : Column(
                              children: [
                                _mainContent(
                                    context,
                                    MediaQuery.of(context).size.width * 0.9,
                                    value),
                                _actions(
                                    context,
                                    MediaQuery.of(context).size.width * 0.9,
                                    value),
                              ],
                            ),
                      Footer(),
                    ],
                  );
                } else
                  return Center(
                    child: CircularProgressIndicator(),
                  );
              },
            ),
          ),
        ),
      ),
    );
  }
}
