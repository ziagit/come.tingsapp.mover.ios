// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:shipbay/screens/home/home.dart';
import 'package:shipbay/screens/sms/rooms.dart';
import 'package:shipbay/shared/components/card_decoration.dart';
import 'package:shipbay/shared/components/slide_right_route.dart';
import 'package:shipbay/shared/components/snackbar.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shared/services/store.dart';
import 'package:shipbay/shared/functions/date_formatter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:convert';

class JobDetails extends StatefulWidget {
  final id;
  JobDetails({Key key, this.id});
  @override
  _JobDetailsState createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  bool _isLoading = true;
  Store store = Store();
  var _job;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Job details"),
        backgroundColor: Tingsapp.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.map,
              ),
              onPressed: () {
                _track(context);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      body: Container(
          child: FutureBuilder(
        future: _get(widget.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              shrinkWrap: true,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
                  padding: EdgeInsets.all(20.0),
                  decoration: cardDecoration(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Status: ${_job['order_detail']['status']}",
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text("Job:")),
                          Text("${_job['order_detail']['uniqid']}")
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text("Placed on:")),
                          Text("${dateFormatter(_job['created_at'])}")
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text("Pickup:")),
                          Flexible(
                              child: Text(
                                  "${_job['order_detail']['addresses'][0]['formatted_address']}"))
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text("Floor:")),
                          Text("${_job['order_detail']['floor_from']}")
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text("Destination:")),
                          Flexible(
                              child: Text(
                                  "${_job['order_detail']['addresses'][1]['formatted_address']}"))
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text("Floor:")),
                          Text("${_job['order_detail']['floor_to']}")
                        ],
                      ),
                      _job['order_detail']['movingtype']['code'] == 'apartment'
                          ? Row(
                              children: [
                                SizedBox(
                                    width: 100, child: Text("Moving size:")),
                                Text(
                                    "${_job['order_detail']['movingsize']['title']}")
                              ],
                            )
                          : Container(),
                      _job['order_detail']['movingtype']['code'] == 'office'
                          ? Row(
                              children: [
                                SizedBox(
                                    width: 100, child: Text("Office size:")),
                                Text(
                                    "${_job['order_detail']['officesize']['title']}")
                              ],
                            )
                          : Container(),
                      _job['order_detail']['movernumber'] != null
                          ? Row(
                              children: [
                                SizedBox(
                                    width: 100,
                                    child: Text("Number of movers:")),
                                Text(
                                    "${_job['order_detail']['movernumber']['number']}")
                              ],
                            )
                          : Container(),
                      _job['order_detail']['vehicle'] != null
                          ? Row(
                              children: [
                                SizedBox(width: 100, child: Text("Vehicle:")),
                                Text(
                                    "${_job['order_detail']['vehicle']['name']}")
                              ],
                            )
                          : Container(),
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text("Schedual date:")),
                          Text("${_job['order_detail']['pickup_date']}")
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text("Time window:")),
                          Text("${_job['order_detail']['appointment_time']}")
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text("Instructions:")),
                          Flexible(
                            child: Text(
                                "${_job['order_detail']['instructions'] != null ? _job['order_detail']['instructions'] : ' '}"),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                _job['order_detail']['supplies'].length > 0
                    ? Container(
                        margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
                        padding: EdgeInsets.all(20.0),
                        decoration: cardDecoration(context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Supplies",
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                            SizedBox(height: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount:
                                      _job['order_detail']['supplies'].length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.all(0.0),
                                      title: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                  "${_job['order_detail']['supplies'][index]['name']}:"),
                                              Text(
                                                  "${_job['order_detail']['supplies'][index]['pivot']['number']}")
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(),
                _job['order_detail']['items'].length > 0
                    ? Container(
                        margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
                        padding: EdgeInsets.all(20.0),
                        decoration: cardDecoration(context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Items",
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                            SizedBox(height: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      _job['order_detail']['items'].length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.all(0.0),
                                      title: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                    "${_job['order_detail']['items'][index]['name']}:"),
                                              ),
                                              Text(
                                                  "${_job['order_detail']['items'][index]['pivot']['number']}")
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(),
                Container(
                  margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
                  padding: EdgeInsets.all(20.0),
                  decoration: cardDecoration(context),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Price",
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(width: 100, child: Text("Total:")),
                            Text("${_job['order_detail']['cost']}")
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 100, child: Text("Moving cost:")),
                            Text("${_job['order_detail']['moving_cost']}")
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 100, child: Text("Travel cost:")),
                            Text("${_job['order_detail']['travel_cost']}")
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 100, child: Text("Service fee:")),
                            Text("${_job['order_detail']['service_fee']}")
                          ],
                        ),
                        _job["order_detail"]['disposal_fee'] != null
                            ? Row(
                                children: [
                                  SizedBox(
                                      width: 100, child: Text("Disposal fee:")),
                                  Text(
                                      "${_job['order_detail']['disposal_fee']}")
                                ],
                              )
                            : Container(),
                        _job["order_detail"]['tips'] != null
                            ? Row(
                                children: [
                                  SizedBox(width: 100, child: Text("Tips:")),
                                  Text("${_job['order_detail']['tips']}")
                                ],
                              )
                            : Container(),
                      ]),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
                  padding: EdgeInsets.all(20.0),
                  decoration: cardDecoration(context),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Customer Contacts",
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(width: 100, child: Text("Name:")),
                            Flexible(
                              child: Text(
                                "${_job['order_detail']['shipper_contacts']['user']['name']}",
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 100, child: Text("Email:")),
                            Flexible(
                              child: Text(
                                "${_job['order_detail']['shipper_contacts']['user']['email']}",
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 100, child: Text("Phone:")),
                            Text(
                              "${_job['order_detail']['shipper_contacts']['user']['phone']}",
                            )
                          ],
                        ),
                      ]),
                ),
              ],
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
      )),
      floatingActionButton: buildSpeedDial(),
    );
  }

  _track(context) {
    Navigator.pushReplacement(
        context,
        SlideRightRoute(
            page: Home(trackingNumber: _job['order_detail']['uniqid'])));
  }

  @override
  void initState() {
    super.initState();
    _job = null;
  }

  Future _get(id) async {
    Api api = new Api();
    var response = await api.get("carrier/jobs/$id");
    if (response.statusCode == 200) {
      _job = jsonDecode(response.body);
      return _job;
    }
  }

  void _update(status) async {
    Api api = new Api();
    setState(() {
      _isLoading = true;
    });
    var data = jsonEncode(<String, Object>{
      'status': status,
      'notificationId': 1,
      'order_detail': _job['order_detail'],
      'id': _job['id'],
      'carrier_id': _job['carrier_id'],
    });
    var res = await api.update(data, "carrier/jobs/${_job['id']}");
    if (res.statusCode == 200) {
      _get(_job['id']);
      setState(() {
        _isLoading = false;
      });
      showSnackbar(context, "Job updated!");
    } else {
      showSnackbar(context, "something is wronge");
    }
  }

  _openChat(context) {
    Navigator.pushReplacement(
      context,
      SlideRightRoute(
        page: Rooms(
            listener: _job['order_detail']['shipper_contacts']['user']['id']),
      ),
    );
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      icon: Icons.menu,
      activeIcon: Icons.close,
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      foregroundColor: Colors.white,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.sms_outlined),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          label: 'Message',
          labelStyle: TextStyle(fontSize: 16.0),
          onTap: () => _openChat(context),
        ),
        SpeedDialChild(
          child: Icon(Icons.check_rounded),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          label: 'Complet',
          labelStyle: TextStyle(fontSize: 16.0),
          onTap: () => _update('Completed'),
        ),
        SpeedDialChild(
          child: Icon(Icons.cancel),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          label: 'Decline',
          labelStyle: TextStyle(fontSize: 16.0),
          onTap: () => _update('Declined'),
        ),
        SpeedDialChild(
          child: Icon(Icons.pending),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          label: 'Accept',
          labelStyle: TextStyle(fontSize: 16.0),
          onTap: () => _update('Accepted'),
        ),
      ],
    );
  }
}
