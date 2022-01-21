import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shipbay/models/address.dart';
import 'package:shipbay/models/mover.dart';
import 'package:shipbay/models/user.dart';
import 'package:shipbay/screens/home/home.dart';
import 'package:shipbay/screens/profile/add_profile.dart';
import 'package:shipbay/screens/profile/edit_account.dart';
import 'package:shipbay/screens/profile/edit_profile.dart';
import 'package:shipbay/screens/profile/upload_file.dart';
import 'package:shipbay/shared/components/card_decoration.dart';
import 'package:shipbay/shared/components/simple_appbar.dart';
import 'package:shipbay/shared/components/slide_right_route.dart';
import 'package:shipbay/shared/components/slide_top_route.dart';
import 'package:shipbay/shared/components/snackbar.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shared/services/store.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Store store = Store();
  User _user;
  Mover _mover;
  Address _address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar("Profile details"),
      body: _mover == null
          ? Container(
              padding: EdgeInsets.all(30),
              child: Center(
                child:
                    CircularProgressIndicator(backgroundColor: Tingsapp.grey),
              ),
            )
          : SingleChildScrollView(
              child: Column(children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: cardDecoration(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child:
                              Text("Account", style: TextStyle(fontSize: 18.0)),
                        ),
                        Row(
                          children: [
                            SizedBox(width: 100, child: Text("Email: ")),
                            Text("${_user.email}")
                          ],
                        ),
                        Row(children: [
                          SizedBox(width: 100, child: Text("Password")),
                          Text("******")
                        ]),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                              onPressed: () {
                                _editAccount(context);
                              },
                              icon: Icon(Icons.edit)),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: cardDecoration(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child:
                              Text("Profile", style: TextStyle(fontSize: 18.0)),
                        ),
                        Row(children: [
                          SizedBox(width: 100, child: Text("First name:")),
                          Text("${_mover.first_name}")
                        ]),
                        Row(children: [
                          SizedBox(width: 100, child: Text("Last name:")),
                          Text("${_mover.last_name}")
                        ]),
                        Row(children: [
                          SizedBox(width: 100, child: Text("Phone:")),
                          Text("${_mover.phone}")
                        ]),
                        Row(children: [
                          SizedBox(width: 100, child: Text("Website:")),
                          Text("${_mover.website}")
                        ]),
                        Row(children: [
                          SizedBox(width: 100, child: Text("Address:")),
                          Flexible(child: Text("${_address.formatted_address}"))
                        ]),
                        Row(children: [
                          SizedBox(width: 100, child: Text("Employees:")),
                          Text("${_mover.employees}")
                        ]),
                        Row(children: [
                          SizedBox(width: 100, child: Text("Vehicles:")),
                          Text("${_mover.vehicles}")
                        ]),
                        Row(children: [
                          SizedBox(width: 100, child: Text("Hourly rate:")),
                          Text("\$${_mover.rate}")
                        ]),
                        Row(children: [
                          SizedBox(width: 100, child: Text("Company name:")),
                          Text("${_mover.company}")
                        ]),
                        Row(children: [
                          SizedBox(
                              width: 100, child: Text("Year established:")),
                          Text("${_mover.year_established}")
                        ]),
                        Row(children: [
                          SizedBox(width: 100, child: Text("More details:")),
                          Flexible(child: Text("${_mover.detail}"))
                        ]),
                        Row(children: [
                          SizedBox(width: 100, child: Text("Insurance paper:")),
                          _mover.insurance == 'undefined'
                              ? IconButton(
                                  onPressed: () => _attachFile('insurance'),
                                  icon: Icon(Icons.attach_file))
                              : Text("File attached")
                        ]),
                        Row(children: [
                          SizedBox(
                              width: 100, child: Text("Business license:")),
                          _mover.license == 'undefined'
                              ? IconButton(
                                  onPressed: () => _attachFile('license'),
                                  icon: Icon(Icons.attach_file))
                              : Text("File attached")
                        ]),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                                onPressed: () {
                                  _editProfil(context);
                                },
                                icon: Icon(Icons.edit)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ]),
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
    var response = await api.get('carrier/details');
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data.length != 0) {
        _mover = Mover(
            data['id'],
            data['first_name'],
            data['last_name'],
            data['user']['phone'],
            data['hourly_rate'],
            data['company'],
            data['detail'],
            data['website'],
            data['business_license'],
            data['insurance_papers'],
            data['votes'].toDouble(),
            data['employees'],
            data['vehicles'],
            data['year_established']);
        _user = User(
            data['user']['id'],
            data['user']['avatar'],
            data['user']['name'],
            data['user']['email'],
            data['user']['phone'],
            '',
            '');
        _address = Address(
            data['address']['id'],
            data['address']['country'],
            data['address']['state'],
            data['address']['city'],
            data['address']['zip'],
            data['address']['street'],
            data['address']['street_number'],
            data['address']['formatted_address']);
        if (mounted) {
          setState(() {});
        }
      } else {
        Navigator.push(context, SlideTopRoute(page: AddProfile()))
            .then((value) {
          if (value != null) {
            Navigator.pushReplacement(context, SlideRightRoute(page: Home()));
          } else {
            _get();
          }
        });
      }
    } else {
      showSnackbar(context, "Something is wrong!");
    }
  }

  _editAccount(context) {
    Navigator.push(context, SlideTopRoute(page: EditAccount(user: _user)))
        .then((value) => {
              if (value != null)
                {_get(), showSnackbar(context, "Updated successfully!")}
            });
  }

  _editProfil(context) {
    Navigator.push(
            context,
            SlideTopRoute(
                page:
                    EditProfile(mover: _mover, user: _user, address: _address)))
        .then((value) => {
              if (value != null)
                {_get(), showSnackbar(context, "Updated successfully!")}
            });
  }

  _attachFile(type) {
    Navigator.push(context,
            SlideTopRoute(page: UploadFile(mover: _mover.id, type: type)))
        .then((value) => {
              if (value != null)
                {_get(), showSnackbar(context, "Updated successfully!")}
            });
  }
}
