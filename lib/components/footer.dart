import 'package:flutter/material.dart';
import '../components/copy.dart';
import '../components/font.dart';

Container buildFooter(Text footerCopy) {
  return Container(
    margin: EdgeInsets.all(10.0),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        footerCopy
      ],
    ),
  );
}

Container footer(String copy) {
  return Container(
    margin: EdgeInsets.all(10.0),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        wrapCopy(copy, normalColorFont(10.0, Colors.blueGrey))
      ],
    ),
  );
}
