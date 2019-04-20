import 'package:flutter/material.dart';
import '../components/copy.dart';
import '../components/font.dart';

class CallToAction extends StatefulWidget {
  final String copy;
  final String redirectLocation;
  final EdgeInsets padding;
  final dynamic onPressedAction;
  final Color color;

  CallToAction({Key key, this.copy, this.redirectLocation, this.padding, this.onPressedAction, this.color})
    : super(key: key);

  @override
  _CallToActionState createState() => _CallToActionState();
}

class _CallToActionState extends State<CallToAction> {
  @override
  Widget build(BuildContext ctx) {
    return Container(
      padding: widget.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            color: widget.color == null ? Color(0xFF1565c0) : widget.color,
            elevation: 4.0,
            child: padWrapCopy(widget.copy, boldColorFont(20.0, Colors.white), EdgeInsets.all(12.0)),
            onPressed: widget.onPressedAction == null ?
            (){ Navigator.of(ctx).pushNamed(widget.redirectLocation); } : widget.onPressedAction,
          )
        ],
      ),
    );
  }
}
