import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invoice_register/list.dart';

Widget createTextView(
    {String title,
    String hint,
    double height,
    TextEditingController controller,
    TextInputType textInputType}) {
  title == null ? title = "Enter title" : title;
  hint == null ? hint = 'Enter hint' : hint;
  height == null ? height = 50.0 : height;

  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Container(
          height: height,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          child: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: textInputType,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
            ),
          ),
        ),
      ),
    ],
  );
}




showSnackBar(String message, final scaffoldKey, Color colorM){
  scaffoldKey.currentState.showSnackBar(new SnackBar(
    backgroundColor: colorM,
    content: Text(
      message,
      style: TextStyle(
        color: Colors.white
      ),
    ),
  ));
}


