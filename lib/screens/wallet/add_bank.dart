import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shipbay/shared/components/simple_appbar.dart';
import 'package:shipbay/shared/components/snackbar.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shared/services/store.dart';

class AddBank extends StatefulWidget {
  @override
  _AddBankState createState() => _AddBankState();
}

class _AddBankState extends State<AddBank> {
  Store store = Store();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSubmiting = false;

  TextEditingController _transitNumberController = TextEditingController();
  TextEditingController _institutionNumberController = TextEditingController();
  TextEditingController _accountNumberController = TextEditingController();
  TextEditingController _confirmAccountNumberController =
      TextEditingController();
  String _currencyDropdown = 'CAD';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: SimpleAppBar("Add bank"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _currencyDropdown,
                    icon: Icon(Icons.keyboard_arrow_down),
                    iconSize: 24,
                    elevation: 12,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      isDense: true,
                    ),
                    style: TextStyle(color: Colors.black),
                    onChanged: (String newValue) {
                      setState(() {
                        _currencyDropdown = newValue;
                      });
                    },
                    items: <String>['CAD', 'USD']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 18),
                  TextFormField(
                    controller: _transitNumberController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Transit number'),
                    style: TextStyle(fontSize: 12.0),
                  ),
                  SizedBox(height: 18),
                  TextFormField(
                    controller: _institutionNumberController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Institution number'),
                    style: TextStyle(fontSize: 12.0),
                  ),
                  SizedBox(height: 18),
                  TextFormField(
                    controller: _accountNumberController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Account number'),
                    style: TextStyle(fontSize: 12.0),
                  ),
                  SizedBox(height: 18),
                  TextFormField(
                    controller: _confirmAccountNumberController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Confirm account number'),
                    style: TextStyle(fontSize: 12.0),
                  ),
                  SizedBox(height: 24),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: _isSubmiting
                        ? CircularProgressIndicator(
                            backgroundColor: Tingsapp.grey,
                          )
                        : ElevatedButton(
                            child: Text("Save"),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _save();
                              }
                            }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  _save() async {
    Api api = new Api();
    setState(() {
      _isSubmiting = true;
    });
    var response = await api.post(
        jsonEncode(<String, dynamic>{
          "currency": _currencyDropdown,
          "transit_number": _transitNumberController.text,
          "institution_number": _institutionNumberController.text,
          "account_number": _accountNumberController.text,
          "confirm_account_number": _confirmAccountNumberController.text,
        }),
        'carrier/bank-info');
    var jsonData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      showSnackbar(context, "${jsonData['error'].toString()}");
    }
  }
}
