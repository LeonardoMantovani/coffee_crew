import 'package:flutter/material.dart';

textInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      fillColor: Colors.brown[50],
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.brown[50], width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.brown[900], width: 2.0),
      )
  );
}