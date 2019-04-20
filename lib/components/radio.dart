import 'package:flutter/material.dart';

Row radio(int value, int groupValue, var onChanged, Color color, Widget content) {
  return Row(
    children: <Widget>[
      Radio(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: color,
      ),
      Container(
        padding: EdgeInsets.only(right: 16.0),
        child: content,
      ),
    ],
  );
}
