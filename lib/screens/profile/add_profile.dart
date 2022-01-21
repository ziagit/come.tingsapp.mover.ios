import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shipbay/shared/components/simple_appbar.dart';
import 'package:shipbay/shared/components/snackbar.dart';
import 'package:shipbay/shared/functions/phone_validator.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/components/google_address.dart';
import 'package:flutter/services.dart';
import 'package:shipbay/shared/services/colors.dart';

class AddProfile extends StatefulWidget {
  final user;
  const AddProfile({Key key, this.user}) : super(key: key);
  @override
  _AddProfileState createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSubmiting = false;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _companyController = TextEditingController();
  TextEditingController _yearEstablishedController = TextEditingController();
  TextEditingController _employeesController = TextEditingController();
  TextEditingController _vehiclesController = TextEditingController();
  TextEditingController _websiteController = TextEditingController();
  TextEditingController _detailController = TextEditingController();
  TextEditingController _rateController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _zipController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _streetNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: SimpleAppBar("Add details"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        labelText: 'First name'),
                    style: TextStyle(fontSize: 12.0),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 18),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Last name'),
                    style: TextStyle(fontSize: 12.0),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 18),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _phoneController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Phone'),
                    style: TextStyle(fontSize: 12.0),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 18),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Address'),
                    style: TextStyle(fontSize: 12.0),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                    onChanged: (keyword) {
                      _openDialog(context, keyword);
                    },
                  ),
                  SizedBox(height: 18),
                  TextFormField(
                    controller: _companyController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Company'),
                    style: TextStyle(fontSize: 12.0),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 18),
                  TextFormField(
                    controller: _yearEstablishedController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(4),
                    ],
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Year established'),
                    style: TextStyle(fontSize: 12.0),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 18),
                  TextFormField(
                    controller: _websiteController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Website'),
                    style: TextStyle(fontSize: 12.0),
                  ),
                  SizedBox(height: 18),
                  TextFormField(
                    controller: _employeesController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Employees'),
                    style: TextStyle(fontSize: 12.0),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 18),
                  TextFormField(
                    controller: _vehiclesController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Vehicles'),
                    style: TextStyle(fontSize: 12.0),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 18),
                  TextFormField(
                    controller: _rateController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Hourly rate'),
                    style: TextStyle(fontSize: 12.0),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 18),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _detailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        labelText: 'About company'),
                    style: TextStyle(fontSize: 12.0),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _isSubmiting
          ? CircularProgressIndicator(backgroundColor: Tingsapp.grey)
          : FloatingActionButton(
              child: Icon(Icons.edit),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _submit();
                }
              },
            ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void _openDialog(context, keyword) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(20),
                color: Colors.white,
                child: Center(
                    child: GoogleAddress(
                        selectedAddress: selected, keyword: keyword)),
              ),
            ),
          ),
        );
      },
    );
  }

  selected(selectedAddress, sessionToken) {
    if (selectedAddress.description != null) {
      setState(() {
        _addressController.text = selectedAddress.description;
        addressDetails(selectedAddress.place_id, sessionToken);
      });
    }
  }

  addressDetails(placeId, sessionToken) async {
    Api api = new Api();
    var res = await api.googleAddressDetails(placeId, sessionToken);
    Map data = jsonDecode(res.body);
    _initAddress(data['result']);
  }

  void _initAddress(address) {
    for (var component in address['address_components']) {
      var types = component['types'];
      if (types.indexOf("street_number") > -1) {
        _streetNumberController.text = component['long_name'];
      }
      if (types.indexOf("route") > -1) {
        _streetController.text = component['long_name'];
      }
      if (types.indexOf("locality") > -1) {
        _cityController.text = component['long_name'];
      }
      if (types.indexOf("administrative_area_level_1") > -1) {
        _stateController.text = component['short_name'];
      }
      if (types.indexOf("postal_code") > -1) {
        _zipController.text = component['long_name'];
      }
      if (types.indexOf("country") > -1) {
        _countryController.text = component['long_name'];
      }
    }
    _addressController.text = address['formatted_address'];
  }

  _submit() async {
    Api api = new Api();
    if (!isValidPhone(_phoneController.text)) {
      showSnackbar(context, "Invalid phone number!");
      return;
    }
    setState(() {
      _isSubmiting = true;
    });
    var response = await api.post(
        jsonEncode(<String, dynamic>{
          "first_name": _firstNameController.text,
          "last_name": _lastNameController.text,
          "website": _websiteController.text,
          "company": _companyController.text,
          "detail": _detailController.text,
          'employees': _employeesController.text,
          'vehicles': _vehiclesController.text,
          'hourly_rate': _rateController.text,
          'year_established': _yearEstablishedController.text,
          'phone': "+1" + _phoneController.text,
          'email': widget.user.email,
          'business_license': '',
          'insurance_papers': '',
          "country": _countryController.text,
          "state": _stateController.text,
          "city": _cityController.text,
          "zip": _zipController.text,
          "street": _streetController.text,
          "street_number": _streetNumberController.text,
          "address": _addressController.text,
        }),
        'carrier/details');
    if (response.statusCode == 200) {
      setState(() {
        _isSubmiting = false;
      });
      Navigator.pop(context, "succeed");
    } else {
      showSnackbar(context, "${response.body}");
    }
  }
}
