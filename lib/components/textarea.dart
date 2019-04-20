import 'package:flutter/material.dart';
import '../components/box.dart';

Container textarea(TextEditingController controller, String hint) {
  return Container(
    decoration: boxNoColor(Colors.grey, 1.0),
    child: Container(
      padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 8.0, bottom: 32.0),
      child: TextFormField(
        style: TextStyle(fontSize: 14.0, color: Colors.black),
        controller: controller,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
        ),
      ),
    ),
  );
}
