import 'package:flutter/material.dart';
import '../components/font.dart';

class Hyperlink extends StatefulWidget {
  final String copy;

  Hyperlink({Key key, this.copy}) : super(key: key);

  @override
  _HyperlinkState createState() => _HyperlinkState();
}

class _HyperlinkState extends State<Hyperlink> {

  @override
  Widget build(BuildContext ctx) {
    return GestureDetector(
      onTap: () {
        var copy = widget.copy.toLowerCase();
        if (copy.contains('terms')) {
          Navigator.of(ctx).pushNamed('/terms');
        } else if (copy.contains('privacy')) {
          Navigator.of(ctx).pushNamed('/privacy');
        } else {
          null;
        }
      },
      child: RichText(
        softWrap: true,
        text: TextSpan(
          text: widget.copy,
          style: normalColorFont(16.0, Colors.blue),
        ),
      ),
    );
  }
}
