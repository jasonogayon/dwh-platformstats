import 'package:flutter/material.dart';

Widget buildTile(Widget child, {Function() onTap}) {
  return Material(
    elevation: 14.0,
    borderRadius: BorderRadius.circular(12.0),
    shadowColor: Color(0x802196F3),
    child: InkWell
    (
      onTap: onTap != null ? () => onTap() : () { print('Not set yet'); },
      child: child
    )
  );
}
