import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shipbay/models/job.dart';
import 'package:shipbay/shared/components/appbar.dart';
import 'package:shipbay/shared/components/menu.dart';
import 'package:shipbay/screens/jobs/job_details.dart';
import 'package:shipbay/shared/components/slide_right_route.dart';
import 'package:shipbay/shared/components/snackbar.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shared/services/store.dart';

class Jobs extends StatefulWidget {
  @override
  _JobsState createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  Store store = Store();
  List<Job> _jobs = [];
  int currentPage = 1;
  int lastPage = 1;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MovingAppBar('Jobs'),
      drawer: MovingMenu(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _isLoading
            ? Center(
                child:
                    CircularProgressIndicator(backgroundColor: Tingsapp.grey))
            : bodyData(),
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

  @override
  void initState() {
    super.initState();
    _get(currentPage);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget bodyData() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columns: <DataColumn>[
              DataColumn(
                label: Text("Job"),
                numeric: false,
                onSort: (i, b) {},
              ),
              DataColumn(
                label: Text("Pickup date"),
                numeric: false,
                onSort: (i, b) {},
              ),
              DataColumn(
                label: Text("App time"),
                numeric: false,
                onSort: (i, b) {},
              ),
              DataColumn(
                label: Text("Type"),
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
            rows: _jobs
                .map(
                  (job) => DataRow(
                    cells: [
                      DataCell(Text("${job.jobId}")),
                      DataCell(Text("${job.pickupDate}")),
                      DataCell(Text("${job.appointmentTime}")),
                      DataCell(Text("${job.type}")),
                      DataCell(Text("\$${job.price}")),
                      DataCell(Text("${job.status}")),
                      DataCell(
                          IconButton(
                            icon: Icon(Icons.more_horiz),
                            onPressed: () {
                              _edit(job.id);
                            },
                          ),
                          showEditIcon: false,
                          placeholder: false),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      );

  _get(currentPage) async {
    setState(() {
      _isLoading = true;
    });
    Api api = new Api();
    var response = await api.get('carrier/jobs?page=$currentPage');
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _jobs = (data['data'] as List).map((e) => Job.fromJson(e)).toList();
      lastPage = data['last_page'];
      _isLoading = false;
      if (mounted) {
        setState(() {});
      }
    } else {
      showSnackbar(context, "somethig is wrong with api");
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
    Navigator.push(context, SlideRightRoute(page: JobDetails(id: id)));
  }
}
