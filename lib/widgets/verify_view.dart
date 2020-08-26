import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

class VerifyView {
  Future _checkUser(String pass, Function callback) async {
    List col = await FirebaseFirestore.instance
        .collection('password')
        .get()
        .then((val) {
      return val.docs;
    });
    String response = col[0].documentID.toString();
    var bytes = utf8.encode(pass); // data being hashed

    var digest = sha256.convert(bytes);
    callback(digest.toString().compareTo(response) == 0);
  }

  void checkPermission(context, callback) {
    TextEditingController _passController = new TextEditingController();
    IconData icon = Icons.visibility_off;
    bool _obscure = true;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Xác nhận'),
        content: Container(
          width: 300,
          child: StatefulBuilder(
            builder: (context, setState) => TextField(
              controller: _passController,
              obscureText: _obscure,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: 'Password',
                labelText: 'Password',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(icon),
                  onPressed: () {
                    setState(() {
                      if (icon == Icons.visibility)
                        icon = Icons.visibility_off;
                      else
                        icon = Icons.visibility;
                      _obscure = !_obscure;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
        actions: [
          FlatButton(
            onPressed: () async {
              List col = await FirebaseFirestore.instance
                  .collection('password')
                  .get()
                  .then((val) {
                return val.docs;
              });
              String response = col[0].documentID.toString();
              var bytes =
                  utf8.encode(_passController.text); // data being hashed

              var digest = sha256.convert(bytes);
              callback(digest.toString().compareTo(response) == 0);
            },
            child: Text('Xác nhận'),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Đóng'),
          ),
        ],
      ),
    );
  }
}
