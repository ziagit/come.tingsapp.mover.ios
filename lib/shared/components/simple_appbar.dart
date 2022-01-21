import 'package:flutter/material.dart';
import 'package:shipbay/shared/services/colors.dart';

class SimpleAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String title;
  SimpleAppBar(
    this.title, {
    Key key,
  })  : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Tingsapp.transparent,
      elevation: 0,
      title: Text(title),
      centerTitle: true,
    );
  }
}
