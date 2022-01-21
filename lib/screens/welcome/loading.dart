import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shipbay/shared/components/asset_image.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shared/services/store.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String name = 'Loading';

  void init() async {
    Api api = new Api();
    final store = Store();
    String token = await store.read('token');
    if (token != null) {
      var response = await api.get('carrier/details');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        await store.save('mover', {
          'company': data['company'],
          'votes': data['votes'],
          'user': data['user_id']
        });
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pushReplacementNamed(context, '/welcome');
        });
      }
    } else {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(context, '/welcome');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SizedBox(
                height: 80, width: 80, child: assetImage(context, "logo.png")),
          ),
          Center(
              child: CircularProgressIndicator(backgroundColor: Tingsapp.grey))
        ],
      ),
    );
  }
}
