import 'package:flutter/material.dart';

Row twoColumnData(
  EdgeInsets padding,
  double firstColWidth,
  double secondColWidth,
  CrossAxisAlignment firstColAlignment,
  CrossAxisAlignment secondColAlignment,
  List<Widget> firstColData,
  List<Widget> secondColData,
) {
  return Row(
    children: <Widget>[
      Container(
        width: firstColWidth,
        padding: padding,
        child: Column(
          crossAxisAlignment: firstColAlignment,
          children: firstColData,
        ),
      ),
      Container(
        width: secondColWidth,
        padding: padding,
        child: Column(
          crossAxisAlignment: secondColAlignment,
          children: secondColData,
        ),
      ),
    ],
  );
}
