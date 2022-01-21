import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:shipbay/models/jobStatus.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/colors.dart';

class JobStatusChart extends StatefulWidget {
  const JobStatusChart({Key key}) : super(key: key);

  @override
  _JobStatusChartState createState() => _JobStatusChartState();
}

class _JobStatusChartState extends State<JobStatusChart> {
  List<charts.Series<JobStatus, String>> _seriesPieData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _seriesPieData =
        List<charts.Series<JobStatus, String>>.empty(growable: true);
    _init();
  }

  @override
  void dispose() {
    _seriesPieData.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? Container(
              child: CircularProgressIndicator(backgroundColor: Tingsapp.grey))
          : charts.PieChart(
              _seriesPieData,
              animate: true,
              animationDuration: Duration(seconds: 2),
              behaviors: [
                charts.DatumLegend(
                  outsideJustification: charts.OutsideJustification.endDrawArea,
                  desiredMaxRows: 2,
                  cellPadding: EdgeInsets.only(top: 30),
                  entryTextStyle: charts.TextStyleSpec(
                    color: charts.MaterialPalette.purple.shadeDefault,
                    fontFamily: 'Georgia',
                    fontSize: 11,
                  ),
                )
              ],
              defaultRenderer: charts.ArcRendererConfig(
                arcWidth: 60,
                arcRendererDecorators: [
                  charts.ArcLabelDecorator(
                      labelPosition: charts.ArcLabelPosition.inside)
                ],
              ),
            ),
    );
  }

  _init() async {
    Api api = new Api();
    var response = await api.get("carrier/dashboard/pie-chart");
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      await _calculate(data);
      _isLoading = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  _calculate(data) {
    int re = 0;
    int ac = 0;
    int de = 0;
    int co = 0;
    int pe = 0;
    for (int i = 0; i < data.length; i++) {
      re = re + 1;
      switch (data[i]['order']['status']) {
        case 'Declined':
          de = de + 1;
          break;
        case 'Accepted':
          ac = ac + 1;
          break;
        case 'Completed':
          co = co + 1;
          break;
        default:
          pe = pe + 1;
      }
    }
    var pieData = [
      JobStatus('Received', re, Tingsapp.received),
      JobStatus('Pending', pe, Tingsapp.pending),
      JobStatus('Accepted', ac, Tingsapp.accepted),
      JobStatus('Declined', de, Tingsapp.declined),
      JobStatus('Completed', co, Tingsapp.completed),
    ];
    _seriesPieData.add(
      charts.Series(
        data: pieData,
        domainFn: (JobStatus job, _) => job.job,
        measureFn: (JobStatus job, _) => job.jobvalue,
        colorFn: (JobStatus job, _) =>
            charts.ColorUtil.fromDartColor(job.colorval),
        id: 'Daily task',
        labelAccessorFn: (JobStatus row, _) => '${row.jobvalue}',
      ),
    );
  }
}
