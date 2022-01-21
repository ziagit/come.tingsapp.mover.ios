// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shipbay/shared/services/api.dart';

class SyncGoogle extends StatefulWidget {
  const SyncGoogle({Key key}) : super(key: key);

  @override
  _SyncGoogleState createState() => _SyncGoogleState();
}

class _SyncGoogleState extends State<SyncGoogle> {
  bool _isLoading = false;
  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Syncing Google",
              style: TextStyle(fontSize: 20),
            ),
            JumpingDotsProgressIndicator(fontSize: 22.0)
          ],
        ),
      ),
    );
  }

  _init() async {
    Api api = new Api();
    setState(() {
      _isLoading = true;
    });
    var response = await api.get('carrier/calendar-sync');
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      Navigator.of(context).pop();
    }
  }
}
