import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/box.dart';
import '../utils/regex.dart';


class CreditCardTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final double width;
  final bool obscureText;

  CreditCardTextField({Key key, this.controller, this.hint, this.width, this.obscureText})
    : super(key: key);

  @override
  _CreditCardTextFieldState createState() => _CreditCardTextFieldState();
}

class _CreditCardTextFieldState extends State<CreditCardTextField> {
  @override
  Widget build(BuildContext ctx) {
    String hint = widget.hint;

    return Container(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        width: widget.width,
        decoration: boxNoColor(Colors.grey, 1.0),
        child: TextFormField(
          style: TextStyle(fontSize: 14.0, color: Colors.black),
          controller: widget.controller,
          obscureText: widget.obscureText,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: hint,
          ),
          keyboardType: _keyboardType(hint),
          inputFormatters: [
            LengthLimitingTextInputFormatter(_inputMaxLength(hint)),
          ],
          validator: (str) =>
            str.isEmpty
              ? hint.toLowerCase().contains('mm') || hint.toLowerCase().contains('yyyy') || hint.toLowerCase().contains('***')
                ? 'Required'
                : 'Enter in your ${hint.toLowerCase()} please'
              : hint.toLowerCase().contains('email')
                ? isEmail(str) ? null : 'Enter in a valid email please'
                : hint.toLowerCase().contains('card number')
                  ? isCreditCard(str) ? null : 'Enter in a valid card number please'
                  : hint.toLowerCase().contains('***')
                    ? str.length >= 3 ? null : '3-4 Digits'
                : null,
        ),
      ),
    );
  }
}

TextInputType _keyboardType(String hint) {
  hint = hint.toLowerCase();
  if (hint.contains('***') || hint.contains('card number') || hint.contains('mm') || hint.contains('yyyy')) {
    return TextInputType.numberWithOptions();
  } else if (hint.contains('email')) {
    return TextInputType.emailAddress;
  } else if (hint.contains('mobile')) {
    return TextInputType.phone;
  } else {
    return TextInputType.text;
  }
}

int _inputMaxLength(String hint) {
  hint = hint.toLowerCase();
  if (hint.contains('***') || hint.contains('yyyy')) {
    return 4;
  } else if (hint.contains('mm')) {
    return 2;
  } else if (hint.contains('card number')) {
    return 16;
  } else {
    return 50;
  }
}
