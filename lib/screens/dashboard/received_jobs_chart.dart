import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:shipbay/models/receivedJob.dart';
import 'package:shipbay/shared/functions/months.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/colors.dart';

class ReceivedJobsChart extends StatefulWidget {
  const ReceivedJobsChart({Key key}) : super(key: key);

  @override
  _ReceivedJobsChartState createState() => _ReceivedJobsChartState();
}

class _ReceivedJobsChartState extends State<ReceivedJobsChart> {
  List<charts.Series<ReceivedJob, String>> _seriesData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _seriesData =
        List<charts.Series<ReceivedJob, String>>.empty(growable: true);
    _init();
  }

  @override
  void dispose() {
    _seriesData.clear();
    super.dispose();
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
                    child: charts.BarChart(
                      _seriesData,
                      animate: true,
                      barGroupingType: charts.BarGroupingType.grouped,
                      animationDuration: Duration(seconds: 2),
                      behaviors: [
                        charts.ChartTitle('Months',
                            behaviorPosition: charts.BehaviorPosition.bottom,
                            titleOutsideJustification:
                                charts.OutsideJustification.middleDrawArea),
                        charts.ChartTitle('Jobs',
                            behaviorPosition: charts.BehaviorPosition.start,
                            titleOutsideJustification:
                                charts.OutsideJustification.middleDrawArea),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }

  _init() async {
    Api api = new Api();
    var response = await api.get("carrier/dashboard/column-chart");
    var jsonData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      await _calculate(jsonData);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  _calculate(jsonData) {
    int jan = 0;
    int feb = 0;
    int mar = 0;
    int apr = 0;
    int may = 0;
    int jun = 0;
    int jul = 0;
    int aug = 0;
    int sep = 0;
    int oct = 0;
    int nov = 0;
    int dec = 0;
    for (int i = 0; i < jsonData.length; i++) {
      DateTime date = DateTime.parse(jsonData[i]['created_at']);
      switch (getMonthName(date.month)) {
        case 'Jan':
          jan += 1;
          break;
        case 'Feb':
          feb += 1;
          break;
        case 'Mar':
          mar += 1;
          break;
        case 'Apr':
          apr += 1;
          break;
        case 'May':
          may += 1;
          break;
        case 'Jun':
          jun += 1;
          break;
        case 'Jul':
          jul += 1;
          break;
        case 'Aug':
          aug += 1;
          break;
        case 'Sep':
          sep += 1;
          break;
        case 'Oct':
          oct += 1;
          break;
        case 'Nov':
          nov += 1;
          break;
        case 'Dec':
          dec += 1;
      }
    }
    var data1 = [
      new ReceivedJob('Jan', jan),
      new ReceivedJob('Feb', feb),
      new ReceivedJob('Mar', mar),
      new ReceivedJob('Apr', apr),
      new ReceivedJob('may', may),
      new ReceivedJob('Jun', jun),
      new ReceivedJob('Jul', jul),
      new ReceivedJob('Aug', aug),
      new ReceivedJob('Sep', sep),
      new ReceivedJob('Oct', oct),
      new ReceivedJob('Nov', nov),
      new ReceivedJob('Dec', dec),
    ];
    _seriesData.add(
      charts.Series(
        domainFn: (ReceivedJob job, _) => job.month,
        measureFn: (ReceivedJob job, _) => job.quantity,
        id: '2017',
        data: data1,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (ReceivedJob job, _) =>
            charts.ColorUtil.fromDartColor(Color(0xffffa500)),
      ),
    );
  }
}
