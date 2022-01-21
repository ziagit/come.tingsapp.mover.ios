import 'package:flutter/material.dart';

Image assetImage(context, name) {
  return Image(image: AssetImage("assets/images/" + name));
}
