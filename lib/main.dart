import 'package:flutter/material.dart';
import 'package:web_app_demo/model/post_model.dart';
import 'package:web_app_demo/model/screen_arg.dart';
import 'package:web_app_demo/view/category_page.dart';
import 'package:web_app_demo/view/edit_post_page.dart';
import 'package:web_app_demo/view/home_page.dart';
import 'package:web_app_demo/view/post_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var routes = <String, WidgetBuilder>{
      MyHomePage.routeName: (context) => new MyHomePage(),
      //PostPage.routeName: (context) => new PostPage(),
      //CategoryPage.routeName: (context) => new CategoryPage(),
    };
    return MaterialApp(
      title: 'Blog phoenix',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
//      home: MyHomePage(title: 'Blog phoenix'),
      home: MyHomePage(),
      onGenerateRoute: (settings) {
        List<String> url = settings.name.split('?');
        if (url[0] == PostPage.routeName) {
          if (url.length > 1) {
            ScreenArg args = new ScreenArg(url[1]);
            return MaterialPageRoute(
              settings: settings,
              builder: (context) {
                return PostPage(
                  arg: args,
                );
              },
            );
          }
          return MaterialPageRoute(
            settings: new RouteSettings(name: 'MyHomePage'),
            builder: (context) {
              return MyHomePage();
            },
          );
        } else if (url[0] == CategoryPage.routeName) {
          if (url.length > 1) {
            return MaterialPageRoute(
              settings: settings,
              builder: (context) {
                return CategoryPage(
                  name: url[1],
                );
              },
            );
          }
          return MaterialPageRoute(
            settings: new RouteSettings(name: 'MyHomePage'),
            builder: (context) {
              return MyHomePage();
            },
          );
        } else if (settings.name == EditPost.routeName) {
          PostModel post = settings.arguments;
          return MaterialPageRoute(
            settings: settings,
            builder: (context) {
              return EditPost(
                post,
              );
            },
          );
        }
        return null;
      },
      routes: routes,
    );
  }
}
