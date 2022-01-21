import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shipbay/shared/services/colors.dart';

class Progress extends StatefulWidget {
  final double progress;
  Progress({this.progress});
  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  @override
  Widget build(BuildContext context) {
    double prgValue = widget.progress != null ? widget.progress : 0.0;
    String perce = prgValue.toStringAsFixed(0);
    return Container(
      child: CircularPercentIndicator(
        radius: 120.0,
        lineWidth: 13.0,
        animation: true,
        animationDuration: 1200,
        percent: prgValue / 100,
        center: Text(
          "$perce%",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        circularStrokeCap: CircularStrokeCap.round,
        backgroundColor: Tingsapp.lightOrange,
      ),
    );
  }
}
