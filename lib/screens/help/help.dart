import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shipbay/shared/components/simple_appbar.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/colors.dart';

class Help extends StatefulWidget {
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar('Help center'),
      body: FutureBuilder(
        future: _get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Html(
                    data: "${snapshot.data}",
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Padding(
              child: Text("Error: ${snapshot.error}"),
              padding: EdgeInsets.only(top: 8),
            );
          } else {
            return Center(
                child:
                    CircularProgressIndicator(backgroundColor: Tingsapp.grey));
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Future _get() async {
    Api api = new Api();
    var response = await api.get('get-carrier-page');
    var jsonData = jsonDecode(response.body);
    return jsonData['body'];
  }
}
