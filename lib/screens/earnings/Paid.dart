import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shipbay/models/earning.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/functions/calculator.dart';
import 'package:shipbay/shared/functions/date_formatter.dart';
import 'package:shipbay/shared/services/colors.dart';

class Paid extends StatefulWidget {
  const Paid({Key key}) : super(key: key);

  @override
  _PaidState createState() => _PaidState();
}

class _PaidState extends State<Paid> {
  List<Earning> _earnings = [];
  int currentPage = 1;
  int lastPage = 1;
  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Container(
              child: Center(
                child:
                    CircularProgressIndicator(backgroundColor: Tingsapp.grey),
              ),
            )
          : _earnings.length > 0
              ? bodyData()
              : Center(
                  child: Text("You are not paid yet!"),
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: lastPage > 1,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FloatingActionButton(
                mini: true,
                backgroundColor: Colors.white,
                heroTag: 1,
                onPressed: () => _prevPage(currentPage),
                child: Icon(Icons.arrow_left),
              ),
              FloatingActionButton(
                mini: true,
                heroTag: 2,
                onPressed: () => _nextPage(currentPage),
                child: Icon(Icons.arrow_right),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bodyData() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              DataTable(
                columns: <DataColumn>[
                  DataColumn(
                    label: Text("Job"),
                    numeric: false,
                    onSort: (i, b) {},
                  ),
                  DataColumn(
                    label: Text("Date"),
                    numeric: false,
                    onSort: (i, b) {},
                  ),
                  DataColumn(
                    label: Text("Price"),
                    numeric: false,
                    onSort: (i, b) {},
                  ),
                  DataColumn(
                    label: Text("Status"),
                    numeric: false,
                    onSort: (i, b) {},
                  ),
                  DataColumn(
                    label: Text("Details"),
                    numeric: false,
                    onSort: (i, b) {},
                  ),
                ],
                rows: _earnings
                    .map(
                      (earning) => DataRow(
                        cells: [
                          DataCell(Text("${earning.jobId}")),
                          DataCell(Text("${dateFormatter(earning.createdAt)}")),
                          DataCell(Text("\$${earning.price}")),
                          DataCell(Text("${earning.status}")),
                          DataCell(
                              IconButton(
                                icon: Icon(Icons.more_horiz),
                                onPressed: () {
                                  _edit(earning.id);
                                },
                              ),
                              showEditIcon: false,
                              placeholder: false),
                        ],
                      ),
                    )
                    .toList(),
              ),
              DataTable(columns: [
                DataColumn(
                  label: Text(""),
                ),
                DataColumn(
                  label: Text(""),
                ),
              ], rows: [
                DataRow(
                  cells: [
                    DataCell(
                      Text("Blance"),
                    ),
                    DataCell(
                      Text("\$${totalPayments(_earnings)}"),
                    ),
                  ],
                ),
              ])
            ],
          ),
        ),
      );

  @override
  void initState() {
    super.initState();
    _get(currentPage);
  }

  _get(currentPage) async {
    Api api = new Api();
    setState(() {
      _isLoading = true;
    });
    var response = await api.get('carrier/paid?page=$currentPage');
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _earnings =
          (data['data'] as List).map((e) => Earning.fromJson(e)).toList();
      lastPage = data['last_page'];
      _isLoading = false;

      if (mounted) {
        setState(() {});
      }
    }
  }

  _nextPage(currentPage) {
    currentPage++;
    _get(currentPage);
  }

  _prevPage(currentPage) {
    currentPage--;
    _get(currentPage);
  }

  _edit(id) {
    Navigator.pushNamed(context, '/earning-details', arguments: id);
  }
}
