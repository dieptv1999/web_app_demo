import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_app_demo/model/post_model.dart';
import 'package:web_app_demo/model/screen_arg.dart';
import 'package:web_app_demo/services/category_provider.dart';
import 'package:web_app_demo/services/post_provider.dart';
import 'package:web_app_demo/view/post_page.dart';
import 'package:web_app_demo/widgets/appbar.dart';
import 'package:web_app_demo/widgets/footer.dart';
import 'package:web_app_demo/widgets/verify_view.dart';

import '../model/category_model.dart';
import 'category_page.dart';
import 'edit_post.dart';

class MyHomePage extends StatefulWidget {
  static String routeName = 'MyHomePage';

  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dropdownValue = 'Home';
  double _categoryItemSize = 200;
  int _maxLine = 1;
  double _hPost = 200; // chiều cao của thẻ bài viết

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

  Widget _searchView() {
    return FutureProvider<List<String>>(
      create: (_) => PostProvider().getAllPostName(),
      child: Consumer<List<String>>(builder: (_, suggestions, __) {
        if (suggestions != null) {
          return Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: AutoCompleteTextField<String>(
                        //maxLines: 1,

                        suggestions: suggestions,
                        itemBuilder: (context, suggestion) => Padding(
                            child: new ListTile(
                              title: new Text(suggestion),
                              //trailing: new Text("Stars: ${suggestion.stars}"),
                            ),
                            padding: EdgeInsets.all(8.0)),
//                  itemSorter: (a, b) =>
//                      a.stars == b.stars ? 0 : a.stars > b.stars ? -1 : 1,
                        itemSubmitted: (val) {},
                        itemFilter: (suggestion, input) => suggestion
                            .toLowerCase()
                            .startsWith(input.toLowerCase()),
                        style: TextStyle(height: 1.2, fontSize: 16),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Search',
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintStyle: TextStyle(
                              fontSize: 16,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 50,
                child: IconButton(
                  alignment: Alignment.centerRight,
                  icon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          );
        }
        return Center(
          child: LinearProgressIndicator(),
        );
      }),
    );
  }

  Widget _categoryView() {
    return FutureProvider<List<CategoryModel>>(
      create: (_) => CategoryProvider().getCategory(),
      child: Consumer<List<CategoryModel>>(
        builder: (_, val, __) {
          if (val != null) {
            return Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 40.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  CategoryModel category = val.elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, CategoryPage.routeName + '?' + category.id,
                            arguments: val.elementAt(index));
                      },
                      child: Container(
                        width: _categoryItemSize - 20,
                        child: Card(
                          child: Stack(
                            children: [
                              Image.network(
                                category.image,
                                fit: BoxFit.fill,
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${category.tag}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: val.length,
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _postsView(wid) {
    return FutureProvider<List<PostModel>>(
      create: (_) => PostProvider().getAllPost(),
      child: Consumer<List<PostModel>>(
        builder: (_, val, __) {
          if (val != null) {
            List<Widget> postsWidget = new List();
            val.forEach((element) {
              postsWidget.add(
                Container(
                  height: _hPost,
                  width: wid,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        PostPage.routeName + '?' + element.id,
                      );
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 200,
                          child: Image.network(element.topicPhoto),
                        ),
                        Expanded(
                          child: Container(
                            height: _hPost,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      element.title,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: _maxLine,
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontFamily: 'RobotoRegular',
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      element.subContent,
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: _maxLine + 1,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'RobotoRegular',
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      element.createAt + ' - 2 min read',
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: 'RobotoRegular',
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  decoration: _shadowBox,
                ),
              );
              postsWidget.add(SizedBox(height: 15));
            });
            return Align(
              child: Column(
//              mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: postsWidget,
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _profileWidget(wid) {
    return Container(
      width: wid,
      child: Column(
        children: [
          Container(
            width: wid,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'ABOUT ME',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
            decoration: _shadowBox,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Image.network(
                'https://i.ibb.co/LtYZTz3/Anh-avatar-dep-cho-con-trai-1.jpg'),
            decoration: _shadowBox,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              'Trần Văn Điệp',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'DancingScript',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Text(
              'I am a web developer focusing on back-end development. Always hungry to keep learning.',
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: wid,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'FOLLOW ME',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
            decoration: _shadowBox,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: wid,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'CATEGORY',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
            decoration: _shadowBox,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < 968) {
      _maxLine = 2;
      _hPost = 200;
    } else {
      _maxLine = 1;
      _hPost = 150;
    }

    return Scaffold(
      appBar: MyAppBar(context).getHomeAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.45,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: Container(
                      child: Center(
                        child: Image.asset('assets/logo_black.png'),
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/background2.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: _searchView(),
                      decoration: BoxDecoration(
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
                          ]),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: _categoryItemSize,
              child: _categoryView(),
            ),
            SizedBox(
              height: 30,
            ),
            MediaQuery.of(context).size.width > 968
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.025),
                        child: _postsView(
                            MediaQuery.of(context).size.width * 0.65),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.025),
                        child: _profileWidget(
                            MediaQuery.of(context).size.width * 0.25),
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.025),
                        child: _postsView(
                            MediaQuery.of(context).size.width * 0.95),
                      ),
                      Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.025),
                        child: _profileWidget(
                            MediaQuery.of(context).size.width * 0.95),
                      ),
                    ],
                  ),
            SizedBox(
              height: 20,
            ),
            Footer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          VerifyView().checkPermission(context, (val) {
            if (val) {
              Navigator.pushNamed(context, EditPost.routeName,
                  arguments: new PostModel(
                    content: '',
                    subContent: '',
                    topicPhoto: '',
                    title: '',
                  ));
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
        tooltip: 'Edit',
        child: Icon(Icons.edit),
      ),
    );
  }
}
