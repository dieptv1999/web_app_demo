import 'package:flutter/material.dart';

class H1 extends StatelessWidget {
  final String title;

  const H1({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0,top: 5,bottom: 5),
      child: Text(
        title,
        style: TextStyle(fontSize: 20),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class H2 extends StatelessWidget {
  final String title;

  const H2({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0,top: 5,bottom: 5),
      child: Text(
        title,
        style: TextStyle(fontSize: 18),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
class H3 extends StatelessWidget {
  final String title;

  const H3({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0,top: 5,bottom: 5),
      child: Text(
        title,
        style: TextStyle(fontSize: 16),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
class H4 extends StatelessWidget {
  final String title;

  const H4({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0,top: 5,bottom: 5),
      child: Text(
        title,
        style: TextStyle(fontSize: 14),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}