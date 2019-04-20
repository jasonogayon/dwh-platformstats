import 'package:flutter/material.dart';
import '../components/copy.dart';
import '../components/font.dart';

class CheckboxInput extends StatefulWidget {
  final String label;
  final bool value;

  CheckboxInput({Key key, this.label, this.value}) : super(key: key);

  @override
  _CheckboxInputState createState() => _CheckboxInputState();
}

class _CheckboxInputState extends State<CheckboxInput> {
  bool _value;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      padding: EdgeInsets.only(top: 8.0),
      child: Row(
        children: <Widget>[
          Checkbox(
            value: _value,
            tristate: false,
            onChanged: (newValue) {
              setState(() {
                _value = newValue;
              });
            },
          ),
          wrapCopy(widget.label, normalFont(14.0)),
        ],
      ),
    );
  }
}
