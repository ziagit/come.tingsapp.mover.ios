import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shipbay/models/paymentHistory.dart';
import 'package:shipbay/shared/components/snackbar.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/colors.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({Key key}) : super(key: key);

  @override
  _PaymentHistoryState createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  List<PaidHistory> _payments = [];
  int currentPage = 1;
  int lastPage = 1;
  bool _isLoading = true;
  @override
  void initState() {
    _get(currentPage);
    super.initState();
  }

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
          : _payments.length == 0
              ? Center(child: Text("There is no payment history yet!"))
              : bodyData(),
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
          child: DataTable(
            columns: <DataColumn>[
              DataColumn(
                label: Text("From"),
                numeric: false,
                onSort: (i, b) {},
              ),
              DataColumn(
                label: Text("To"),
                numeric: false,
                onSort: (i, b) {},
              ),
              DataColumn(
                label: Text("Amount"),
                numeric: false,
                onSort: (i, b) {},
              ),
              DataColumn(
                label: Text("Date"),
                numeric: false,
                onSort: (i, b) {},
              )
            ],
            rows: _payments
                .map(
                  (payment) => DataRow(
                    cells: [
                      DataCell(Text("${payment.from}")),
                      DataCell(Text("${payment.to}")),
                      DataCell(Text("${payment.amount}")),
                      DataCell(Text("\$${payment.createdAt}")),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      );
  _get(currentPage) async {
    Api api = new Api();
    setState(() {
      _isLoading = true;
    });
    var response = await api.get("carrier/payments?page=$currentPage");
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _payments =
          (data['data'] as List).map((e) => PaidHistory.fromJson(e)).toList();
      lastPage = data['last_page'];
    } else {
      showSnackbar(context, "${response.body}");
    }
    if (mounted) {
      _isLoading = false;
      setState(() {});
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
}
