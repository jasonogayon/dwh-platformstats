import 'package:flutter/material.dart';
import '../../components/tile.dart';
import '../../components/copy.dart';
import '../../components/font.dart';

class RectangleTile extends StatefulWidget {
  final dynamic label;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Map data;

  RectangleTile({
    Key key, this.label, this.description, this.icon, this.iconColor, this.data
  }) : super(key: key);

  @override
  RectangleTileState createState() => RectangleTileState();
}

class RectangleTileState extends State<RectangleTile> {
  @override
  Widget build(BuildContext ctx) {
    return buildTile(
      Padding(
        padding: EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                wrapCopy(widget.label, normalColorFont(12.0, Colors.blueAccent)),
                wrapCopy(widget.data.toString(), boldColorFont(34.0, Colors.black))
              ],
            ),
            Material(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(24.0),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(Icons.timeline, color: Colors.white, size: 30.0),
                )
              )
            )
          ]
        ),
      ),
    );
  }
}
