import 'package:flutter/material.dart';
import '../components/copy.dart';
import '../components/font.dart';

AppBar statsBanner() {
  return AppBar(
    elevation: 2.0,
    backgroundColor: Color(0xFF1565c0),
    centerTitle: false,
    title: wrapCopy('Platform Stats', boldColorFont(20.0, Colors.white)),
    actions: <Widget>
    [
      Container(
        margin: EdgeInsets.only(right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            wrapCopy('directwithhotels.com', boldColorFont(10.0, Colors.grey[400])),
          ],
        ),
      )
    ],
  );
}
