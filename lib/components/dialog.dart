import 'package:flutter/material.dart';
import 'dart:async';
import '../globals.dart' as globals;

Future<bool> dialog(BuildContext ctx, String name, Widget title, Widget content) {
  return showDialog(
    context: ctx,
    builder: (ctx) =>
      AlertDialog(
        title: title,
        content: content,
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('No'),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop(true);
              globals.cpUser = '';
              globals.cpPass = '';
            },
            child: Text('Yes'),
          ),
        ],
      ),
  ) ?? false;
}
