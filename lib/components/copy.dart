import 'package:flutter/material.dart';
import '../components/font.dart';

Text wrapCopy(String copy, TextStyle copyStyle) {
  return Text(
    copy,
    softWrap: true,
    style: copyStyle,
  );
}

Padding padWrapCopy(String copy, TextStyle copyStyle, EdgeInsets paddingStyle) {
  return Padding(
    padding: paddingStyle,
    child: wrapCopy(copy, copyStyle)
  );
}

Center centerWrapCopy(String copy, TextStyle copyStyle) {
  return Center(
    child: wrapCopy(copy, copyStyle)
  );
}

Center centerPadWrapCopy(String copy, TextStyle copyStyle, EdgeInsets paddingStyle) {
  return Center(
    child: padWrapCopy(copy, copyStyle, paddingStyle)
  );
}

Row iconCopy(String copy, Icon icon, EdgeInsets iconPadding, Color color) {
  return Row(
    children: <Widget>[
      Container(
        padding: iconPadding,
        child: icon,
      ),
      wrapCopy(copy, normalColorFont(14.0, color)),
    ],
  );
}

RichText strikeCopy(String copy, double size) {
  return RichText(
    text: TextSpan(
      text: copy,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey,
        decoration: TextDecoration.lineThrough,
        decorationColor: Colors.blueGrey,
        decorationStyle: TextDecorationStyle.solid,
      ),
    ),
  );
}
