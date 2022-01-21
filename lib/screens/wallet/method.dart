import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shipbay/models/bank.dart';
import 'package:shipbay/screens/wallet/add_bank.dart';
import 'package:shipbay/screens/wallet/edit_bank.dart';
import 'package:shipbay/shared/components/slide_top_route.dart';
import 'package:shipbay/shared/components/snackbar.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/colors.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({Key key}) : super(key: key);

  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  bool _isLoading = true;
  Bank _bankInfo;
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
          : _bankInfo == null
              ? Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("No payment method added"),
                      ],
                    ),
                  ),
                )
              : Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 180, child: Text("Currency:")),
                          Text("${_bankInfo.currency}")
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 180, child: Text("Transit number:")),
                          Text("${_bankInfo.transitNumber}")
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                              width: 180, child: Text("Institution number:")),
                          Text("${_bankInfo.institutionNumber}")
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 180, child: Text("Account number:")),
                          Text("${_bankInfo.accountNumber}")
                        ],
                      ),
                    ],
                  ),
                ),
      floatingActionButton: _bankInfo == null
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                _save(context);
              },
            )
          : FloatingActionButton(
              child: Icon(Icons.edit),
              onPressed: () {
                _edit(context, _bankInfo);
              },
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    _get();
  }

  _get() async {
    Api api = new Api();
    setState(() {
      _isLoading = true;
    });
    var response = await api.get("carrier/bank-info");
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _bankInfo = Bank(data['id'], data['currency'], data['transit_number'],
          data['institution_number'], data['account_number']);
    } else {
      showSnackbar(context, "${response.body}");
    }
    if (mounted) {
      _isLoading = false;
      setState(() {});
    }
  }

  _save(context) {
    Navigator.push(context, SlideTopRoute(page: AddBank())).then((value) => {
          _get(),
        });
  }

  _edit(context, bankInfo) {
    Navigator.push(context, SlideTopRoute(page: EditBank(bank: bankInfo)))
        .then((value) => {
              _get(),
            });
  }
}
