import 'package:flutter/material.dart';

class ConnectGoogle extends StatefulWidget {
  const ConnectGoogle({Key key}) : super(key: key);

  @override
  _ConnectGoogleState createState() => _ConnectGoogleState();
}

class _ConnectGoogleState extends State<ConnectGoogle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
              child: Text("Connect to Google"), onPressed: _launchURL)
          /* Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Connecting to Google",
              style: TextStyle(fontSize: 20),
            ),
            JumpingDotsProgressIndicator(fontSize: 22.0)
          ],
        ), */
          ),
    );
  }

  void _launchURL() async {}
}
