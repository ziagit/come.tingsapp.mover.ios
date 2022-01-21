import 'package:flutter/material.dart';
import 'package:shipbay/screens/home/home.dart';
import 'package:shipbay/screens/welcome/loading.dart';
import 'package:shipbay/screens/welcome/welcome.dart';
import 'package:shipbay/shared/services/colors.dart';

class Routes extends StatelessWidget {
  const Routes({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Open Sans',
        primarySwatch: swatchify(),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => Loading(),
        '/welcome': (_) => Welcome(),
        '/home': (_) => Home(),
      },
    );
  }
}
