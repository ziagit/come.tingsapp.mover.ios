import 'package:flutter/material.dart';

void showSnackbar(context, String msg) {
  final snackBar = SnackBar(content: Text("$msg"));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
