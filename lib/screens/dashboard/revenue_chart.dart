import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:shipbay/models/revenue.dart';
import 'package:shipbay/shared/functions/months.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/colors.dart';

class RevenueChart extends StatefulWidget {
  const RevenueChart({Key key}) : super(key: key);

  @override
  _RevenueChartState createState() => _RevenueChartState();
}

class _RevenueChartState extends State<RevenueChart> {
  List<charts.Series<Revenue, int>> _seriesLineData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _seriesLineData = List<charts.Series<Revenue, int>>.empty(growable: true);
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: _isLoading
            ? CircularProgressIndicator(backgroundColor: Tingsapp.grey)
            : Column(
                children: <Widget>[
                  Expanded(
                    child: _isLoading
                        ? Center(child: Text("Loading..."))
                        : charts.LineChart(_seriesLineData,
                            defaultRenderer: charts.LineRendererConfig(
                                includeArea: true, stacked: true),
                            animate: true,
                            animationDuration: Duration(seconds: 2),
                            behaviors: [
                                charts.ChartTitle('Months',
                                    behaviorPosition:
                                        charts.BehaviorPosition.bottom,
                                    titleOutsideJustification: charts
                                        .OutsideJustification.middleDrawArea),
                                charts.ChartTitle('Amount(\$)',
                                    behaviorPosition:
                                        charts.BehaviorPosition.start,
                                    titleOutsideJustification: charts
                                        .OutsideJustification.middleDrawArea),
                              ]),
                  ),
                ],
              ),
      ),
    );
  }

  _init() async {
    Api api = new Api();
    var response = await api.get("carrier/dashboard/line-chart");
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      await _calculate(data);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  _calculate(data) {
    double jan = 0.0;
    double feb = 0.0;
    double mar = 0.0;
    double apr = 0.0;
    double may = 0.0;
    double jun = 0.0;
    double jul = 0.0;
    double aug = 0.0;
    double sep = 0.0;
    double oct = 0.0;
    double nov = 0.0;
    double dec = 0.0;
    for (int i = 0; i < data.length; i++) {
      DateTime date = DateTime.parse(data[i]['created_at']);
      switch (getMonthName(date.month)) {
        case 'Jan':
          jan += data[i]['carrier_earning'];
          break;
        case 'Feb':
          feb += data[i]['carrier_earning'];
          break;
        case 'Mar':
          mar += data[i]['carrier_earning'];
          break;
        case 'Apr':
          apr += data[i]['carrier_earning'];
          break;
        case 'May':
          may += data[i]['carrier_earning'];
          break;
        case 'Jun':
          jun += data[i]['carrier_earning'];
          break;
        case 'Jul':
          jul += data[i]['carrier_earning'];
          break;
        case 'Aug':
          aug += data[i]['carrier_earning'];
          break;
        case 'Sep':
          sep += data[i]['carrier_earning'];
          break;
        case 'Oct':
          oct += data[i]['carrier_earning'];
          break;
        case 'Nov':
          nov += data[i]['carrier_earning'];
          break;
        case 'Dec':
          dec += data[i]['carrier_earning'];
      }
    }
    var data1 = [
      new Revenue(1, jan),
      new Revenue(2, feb),
      new Revenue(3, mar),
      new Revenue(4, apr),
      new Revenue(5, may),
      new Revenue(6, jun),
      new Revenue(7, jul),
      new Revenue(8, aug),
      new Revenue(9, sep),
      new Revenue(10, oct),
      new Revenue(11, nov),
      new Revenue(12, dec),
    ];

    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xffffa500)),
        id: 'Monthly Revenvue',
        data: data1,
        domainFn: (Revenue rev, _) => rev.month,
        measureFn: (Revenue rev, _) => rev.amount,
      ),
    );
  }
}
