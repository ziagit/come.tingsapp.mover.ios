import 'package:flutter/material.dart';

Decoration logoStyle(context) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(50.0),
    boxShadow: [
      new BoxShadow(
        color: Colors.black45,
        offset: new Offset(0.0, 2.0),
        blurRadius: 10.0,
        spreadRadius: 0.1,
      )
    ],
  );
}

Decoration iconStyle(context) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      new BoxShadow(
        color: Colors.black45,
        offset: new Offset(0.0, 2.0),
        blurRadius: 10.0,
        spreadRadius: 0.1,
      )
    ],
  );
}
