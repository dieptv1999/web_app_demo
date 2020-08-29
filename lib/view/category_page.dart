import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_app_demo/model/category_model.dart';
import 'package:web_app_demo/model/post_model.dart';
import 'package:web_app_demo/services/category_provider.dart';
import 'package:web_app_demo/services/post_provider.dart';
import 'package:web_app_demo/view/post_page.dart';
import 'package:web_app_demo/widgets/appbar.dart';
import 'package:web_app_demo/widgets/footer.dart';
import 'package:web_app_demo/widgets/verify_view.dart';

import 'edit_post_page.dart';

class CategoryPage extends StatefulWidget {
  static String routeName = 'CategoryPage';

  final String name;

  const CategoryPage({Key key, this.name}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CategoryPageState(name);
}

class CategoryPageState extends State<CategoryPage> {
  double _categoryItemSize = 200;
  int _maxLine = 1;
  double _hPost = 200; // chiều cao của thẻ bài viết
  CategoryModel _category;
  final String name;
  bool isCall = false;

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

  CategoryPageState(this.name);

  Widget _searchView() {
    return FutureProvider<List<String>>(
      create: (_) => PostProvider().getListPostNameById(_category.posts),
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

  Widget _postsView(wid) {
    return FutureProvider<List<PostModel>>(
      create: (_) => PostProvider().getListPostById(_category.posts),
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

  Future _getCategoryById() async {
    CategoryModel tmp = await CategoryProvider().getCategoryById(name);
    setState(() {
      _category = tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context).settings.arguments != null)
      _category = ModalRoute.of(context).settings.arguments;
    if (_category == null) {
      if (!isCall) _getCategoryById();
      setState(() {
        isCall = true;
      });
      return Center(
        child: CircularProgressIndicator(),
      );
    }
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
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05, top: 30),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _category.tag,
//                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05),
              child: _postsView(MediaQuery.of(context).size.width * 0.9),
            ),
            SizedBox(
              height: 30,
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
