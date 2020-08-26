import 'package:flutter/material.dart';
import 'package:web_app_demo/view/home_page.dart';

class MyAppBar {
  BuildContext context;

  MyAppBar(this.context);

  PreferredSizeWidget getHomeAppBar() {
    String dropdownValue = 'Home';
    return AppBar(
      backgroundColor: Color.fromARGB(245, 255, 255, 255),
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: Container(
          height: 60,
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.contain,
          )),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.pushNamed(context, MyHomePage.routeName);
          },
          child: Text('Home'),
        ),
//        FlatButton(
//          onPressed: () {},
//          child: Text('Category'),
//        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }

  PreferredSizeWidget getEditAppBar() {
    return AppBar(
      backgroundColor: Color.fromARGB(245, 255, 255, 255),
      title: Container(
          height: 60,
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.contain,
          )),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.pushNamed(context, MyHomePage.routeName);
          },
          child: Text('Home'),
        ),
//        FlatButton(
//          onPressed: () {},
//          child: Text('Category'),
//        ),
        SizedBox(
          width: 20,
        ),
      ],
      bottom: TabBar(
        labelColor: Colors.blue,
        indicatorColor: Colors.black87,
        tabs: [
          Tab(icon: Icon(Icons.edit)),
          Tab(icon: Icon(Icons.remove_red_eye)),
        ],
      ),
    );
  }
}