import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shipbay/screens/earnings/earnings.dart';
import 'package:shipbay/screens/help/help.dart';
import 'package:shipbay/screens/legals/legals.dart';
import 'package:shipbay/screens/profile/profile.dart';
import 'package:shipbay/screens/sms/rooms.dart';
import 'package:shipbay/screens/wallet/wallet.dart';
import 'package:shipbay/shared/components/slide_right_route.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/store.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class MovingMenu extends StatefulWidget {
  @override
  _MovingMenuState createState() => _MovingMenuState();
}

class _MovingMenuState extends State<MovingMenu> {
  Store store = Store();
  String _company;
  double _votes;
  bool _isLogingOut = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 80.0,
                    height: 80.0,
                    margin: EdgeInsets.only(top: 30.0),
                    child: CircleAvatar(
                      radius: 25.0,
                      child: Text(
                        "${_company == null ? '' : _company.substring(0, 2).toUpperCase()}",
                        style: TextStyle(
                            fontSize: 26.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "$_company",
                        style: TextStyle(fontSize: 22.0),
                      ),
                      _votes == null
                          ? Container()
                          : SmoothStarRating(
                              allowHalfRating: false,
                              onRated: (v) {},
                              starCount: 5,
                              rating: _votes,
                              size: 20.0,
                              isReadOnly: true,
                              spacing: 0.0)
                    ],
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          Column(
            children: [
              ListTile(
                leading: Icon(Icons.person_outlined),
                title: Text(
                  "Account",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, SlideRightRoute(page: Profile()));
                },
              ),
              ListTile(
                leading: Icon(Icons.money_outlined),
                title: Text(
                  "Earnings",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, SlideRightRoute(page: Earnings()));
                },
              ),
              ListTile(
                leading: Icon(Icons.credit_card_outlined),
                title: Text(
                  "Wallet",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, SlideRightRoute(page: Wallet()));
                },
              ),
              ListTile(
                leading: Icon(Icons.policy_outlined),
                title: Text(
                  "Legals",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, SlideRightRoute(page: Legals()));
                },
              ),
              ListTile(
                leading: Icon(Icons.help_center_outlined),
                title: Text(
                  "Supports",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, SlideRightRoute(page: Help()));
                },
              ),
              ListTile(
                leading: Icon(Icons.sms_outlined),
                title: Text(
                  "Messages",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context, SlideRightRoute(page: Rooms(listener: 2)));
                },
              ),
              Divider(),
              _isLogingOut
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                          Text("Signing out"),
                          JumpingDotsProgressIndicator(fontSize: 20.0)
                        ])
                  : ListTile(
                      leading: Icon(Icons.logout_outlined),
                      title: Text(
                        "Signout",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w600),
                      ),
                      onTap: () {
                        _logout(context);
                      },
                    ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    _getMe();
    super.initState();
  }

  _logout(context) async {
    Api api = new Api();
    setState(() {
      _isLogingOut = true;
    });
    String token = await store.read('token');
    if (token != null) {
      api.logout(context).then((response) => {}).whenComplete(
            () => {
              store.remove(),
              setState(() {
                _isLogingOut = false;
              }),
              Navigator.pushReplacementNamed(context, '/welcome'),
            },
          );
      return null;
    }
  }

  _getMe() async {
    Api api = new Api();
    var mover = await store.read('mover');
    if (mover == null) {
      var mover = await api.get('carrier/details');
      if (mover.statusCode == 200) {
        var me = jsonDecode(mover.body);
        _company = me['company'];
        _votes = me['votes'].toDouble();
        await store.save('mover', {
          'company': me['company'],
          'votes': me['votes'],
          'user': me['user_id']
        });
      }
    } else {
      _company = mover['company'];
      _votes = mover['votes'].toDouble();
    }
    if (mounted) {
      setState(() {});
    }
  }
}
