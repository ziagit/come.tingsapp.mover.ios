import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shipbay/shared/components/card_decoration.dart';
import 'package:shipbay/shared/components/simple_appbar.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shared/services/store.dart';

class EarningDetails extends StatefulWidget {
  @override
  _EarningDetailsState createState() => _EarningDetailsState();
}

class _EarningDetailsState extends State<EarningDetails> {
  bool _isLoading = true;
  Store store = Store();
  var _earning;
  int _id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar("Status: ${_isLoading ? '' : _earning['status']}"),
      body: Container(
        child: FutureBuilder(
          future: _get(_id),
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
                            "Earning Details",
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(width: 100, child: Text("Travel cost:")),
                            Text("\$${snapshot.data['order']['travel_cost']}")
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 100, child: Text("Moving cost:")),
                            Text("\$${snapshot.data['order']['moving_cost']}")
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 100, child: Text("Received tips:")),
                            Text(
                                "\$${snapshot.data['order']['tips'] != null ? snapshot.data['order']['tips'] : ''}")
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 100, child: Text("Supplies cost:")),
                            Text(
                                "\$${snapshot.data['order']['supplies_cost'] != null ? snapshot.data['order']['supplies_cost'] : ''}")
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 100, child: Text("Disposal fee:")),
                            Flexible(
                                child: Text(
                                    "\$${snapshot.data['order']['disposal_fee'] != null ? snapshot.data['order']['disposal_fee'] : ''}"))
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 100, child: Text("Service fee:")),
                            Text(
                                "\$${snapshot.data['order']['service_fee'] != null ? snapshot.data['order']['service_fee'] : ''}")
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 100, child: Text("Payable tax:")),
                            Text(
                                "\$${snapshot.data['unpaid_gst'] != null ? snapshot.data['unpaid_gst'] : ''}")
                          ],
                        ),
                      ],
                    ),
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
                            "Total",
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text("Total amount to be callected:"),
                            SizedBox(width: 10),
                            Text("\$${_earning['carrier_earning']}"),
                          ],
                        ),
                      ],
                    ),
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
                  child: CircularProgressIndicator(
                      backgroundColor: Tingsapp.grey));
            }
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _id = ModalRoute.of(context).settings.arguments;
    });
  }

  Future _get(id) async {
    Api api = new Api();
    var response = await api.get("carrier/earning/${id}");
    if (response.statusCode == 200) {
      _earning = jsonDecode(response.body);
      return _earning;
    }
  }
}
