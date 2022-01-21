import 'package:flutter/material.dart';
import 'package:shipbay/models/user.dart';
import 'package:shipbay/screens/home/home.dart';
import 'package:shipbay/screens/profile/add_profile.dart';
import 'package:shipbay/shared/components/asset_image.dart';
import 'package:shipbay/shared/components/card_decoration.dart';
import 'package:shipbay/shared/components/input_decoration2.dart';
import 'package:shipbay/shared/components/simple_appbar.dart';
import 'package:shipbay/shared/components/slide_right_route.dart';
import 'package:shipbay/shared/components/snackbar.dart';
import 'package:shipbay/shared/functions/phone_validator.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'dart:convert';
import 'package:shipbay/shared/services/store.dart';
import 'package:pinput/pin_put/pin_put.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  User _user;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _terms = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: SimpleAppBar(""),
      body: OrientationBuilder(builder: (_, orientation) {
        if (orientation == Orientation.portrait)
          return _buildPortraitLayout(); // if orientation is portrait, show your portrait layout
        else
          return _buildLandscapeLayout(); // else show the landscape one
      }),
    );
  }

  Padding _buildPortraitLayout() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          height: 80,
                          width: 80,
                          child: assetImage(context, "logo.png")),
                      SizedBox(height: 10),
                      Text(
                        "tingsapp",
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: cardDecoration(context),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration: inputDecoration2(context, 'Name'),
                            ),
                            TextFormField(
                              controller: _emailController,
                              decoration: inputDecoration2(context, 'Email'),
                            ),
                            TextFormField(
                              controller: _passwordController,
                              decoration: inputDecoration2(context, 'Password'),
                            ),
                            TextFormField(
                              controller: _confirmPasswordController,
                              decoration: inputDecoration2(
                                  context, 'Password confirmation'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.all(0),
                        value: _terms,
                        onChanged: _handleTerms,
                        title: Text("I accept the terms and use"),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _isLoading
                      ? CircularProgressIndicator(
                          backgroundColor: Tingsapp.grey)
                      : SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: 60.0,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                              ),
                            ),
                            child: Text(
                              "SignUp",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18),
                            ),
                            onPressed: () {
                              _register(context);
                            },
                          ),
                        ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Padding _buildLandscapeLayout() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      labelText: 'Name'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      labelText: 'Email'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      labelText: 'Password'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      labelText: 'Password confirmation'),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Flexible(
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.all(0),
                        value: _terms,
                        onChanged: _handleTerms,
                        title: Text("I accept the terms and use"),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    _isLoading
                        ? CircularProgressIndicator(
                            backgroundColor: Tingsapp.grey)
                        : SizedBox(
                            height: 56.0,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                              child: Text(
                                "SignUp",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              ),
                              onPressed: () {
                                _register(context);
                              },
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _handleTerms(value) {
    setState(() {
      _terms = value;
    });
  }

  void _register(context) async {
    Api api = new Api();
    if (_nameController.text.length == 0 ||
        _emailController.text.length == 0 ||
        _passwordController.text.length == 0 ||
        _confirmPasswordController.text.length == 0) {
      showSnackbar(context, "All the fields are required!");
      return null;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      showSnackbar(context, "Passwords does not match!");
      return null;
    }
    if (!_terms) {
      showSnackbar(context, "Accept the terms and use!");
      return null;
    }

    setState(() {
      _isLoading = true;
    });
    var response = await api.post(
        jsonEncode(<String, dynamic>{
          "name": _nameController.text,
          "email": _emailController.text,
          "password": _passwordController.text,
          "password_confirmation": _confirmPasswordController.text,
          "type": 'mover',
        }),
        "auth/verify-email");
    var jsonData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      Navigator.push(
          context,
          SlideRightRoute(
              page: VerifyEmail(
            phone: _emailController.text,
            userId: jsonData,
          ))).then(
        (value) => {
          if (value != null)
            {
              _addDetails(),
            }
        },
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnackbar(context, jsonData);
    }
  }

  _addDetails() async {
    Api api = new Api();
    var me = await api.get('auth/me');
    if (me.statusCode == 200) {
      var jsonUser = jsonDecode(me.body);
      _user = User(jsonUser['id'], jsonUser['avatar'], jsonUser['name'],
          jsonUser['email'], jsonUser['phone'], '', '');
      Navigator.push(context, SlideRightRoute(page: AddProfile(user: _user)))
          .then((value) {
        if (value != null) {
          Navigator.pushReplacement(context, SlideRightRoute(page: Home()));
        }
      });
    }
  }
}

class VerifyEmail extends StatefulWidget {
  final phone;
  final userId;
  const VerifyEmail({Key key, this.phone, this.userId}) : super(key: key);

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  bool _isLoading = false;
  final Store _store = Store();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.black54),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(""),
      body: OrientationBuilder(builder: (_, orientation) {
        if (orientation == Orientation.portrait)
          return _buildPortraitLayout(); // if orientation is portrait, show your portrait layout
        else
          return _buildLandscapeLayout(); // else show the landscape one
      }),
    );
  }

  Padding _buildPortraitLayout() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              height: 80, width: 80, child: assetImage(context, "logo.png")),
          SizedBox(height: 10),
          Text(
            "tingsapp",
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Container(
            child: PinPut(
              fieldsCount: 4,
              onSubmit: (String pin) => _verify(pin, context),
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              submittedFieldDecoration: _pinPutDecoration.copyWith(
                borderRadius: BorderRadius.circular(20.0),
              ),
              selectedFieldDecoration: _pinPutDecoration,
              followingFieldDecoration: _pinPutDecoration.copyWith(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                  color: Colors.black38,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "We texted a code to " + widget.phone,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: _isLoading
                ? CircularProgressIndicator(backgroundColor: Tingsapp.grey)
                : TextButton(
                    onPressed: () => _pinPutController.text = '',
                    child: TextButton(
                        onPressed: () {
                          _resend(context);
                        },
                        child: Text("Resend"))),
          ),
        ],
      ),
    );
  }

  Padding _buildLandscapeLayout() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: PinPut(
              fieldsCount: 4,
              onSubmit: (String pin) => _verify(pin, context),
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              submittedFieldDecoration: _pinPutDecoration.copyWith(
                borderRadius: BorderRadius.circular(20.0),
              ),
              selectedFieldDecoration: _pinPutDecoration,
              followingFieldDecoration: _pinPutDecoration.copyWith(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                  color: Colors.black38,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "We texted a code to " + widget.phone,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              _isLoading
                  ? CircularProgressIndicator(backgroundColor: Tingsapp.grey)
                  : TextButton(
                      onPressed: () => _pinPutController.text = '',
                      child: TextButton(
                        onPressed: () {
                          _resend(context);
                        },
                        child: Text("Resend"),
                      ),
                    ),
            ],
          )
        ],
      ),
    );
  }

  _resend(context) async {
    Api api = new Api();
    setState(() {
      _isLoading = true;
    });
    var response = await api.post(
        jsonEncode(
          <String, dynamic>{
            'email':
                isValidPhone(widget.phone) ? "+1" + widget.phone : widget.phone
          },
        ),
        'auth/check-email');
    var jsonData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (jsonData['role'] == 'mover') {
        _store.save('me', jsonData['id']);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _verify(String pin, BuildContext context) async {
    Api api = new Api();
    setState(() {
      _isLoading = true;
    });
    var response = await api.post(
        jsonEncode(
          <String, dynamic>{"code": pin, "me": widget.userId},
        ),
        'auth/signin');
    if (response.statusCode == 200) {
      var token = jsonDecode(response.body);
      _store.save('token', token);
      _isLoading = false;
      Navigator.of(context).pop('ok');
    } else {
      _isLoading = false;
      showSnackbar(context, "${jsonDecode(response.body)}");
    }
    setState(() {});
  }
}
