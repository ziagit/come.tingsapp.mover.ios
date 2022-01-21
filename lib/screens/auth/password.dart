import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shipbay/screens/auth/forget_password.dart';
import 'package:shipbay/screens/auth/signup.dart';
import 'package:shipbay/shared/components/asset_image.dart';
import 'package:shipbay/shared/components/card_decoration.dart';
import 'package:shipbay/shared/components/input_decoration2.dart';
import 'package:shipbay/shared/components/simple_appbar.dart';
import 'package:shipbay/shared/components/slide_right_route.dart';
import 'package:shipbay/shared/components/snackbar.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shared/services/store.dart';
import 'package:shipbay/shared/services/api.dart';

class Password extends StatefulWidget {
  final userId;
  const Password({Key key, this.userId}) : super(key: key);
  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  Store store = Store();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
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
            child: Form(
                key: _formKey,
                child: Center(
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
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: inputDecoration2(context, 'Password'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Invalid password';
                              }
                              return null;
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: TextButton(
                              onPressed: () {
                                _reset();
                              },
                              child: Text("Reset your password")),
                        )
                      ],
                    ),
                  ),
                )),
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
                              "SignIn",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18),
                            ),
                            onPressed: () {
                              _login(context);
                            },
                          ),
                        ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have account?",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 6),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context, SlideRightRoute(page: Signup()));
                        },
                        child: Text("SignUp"),
                      ),
                    ],
                  )
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
      child: Row(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      labelText: 'Password'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Invalid password';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          _isLoading
              ? CircularProgressIndicator(backgroundColor: Tingsapp.grey)
              : SizedBox(
                  height: 56.0,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    child: Text(
                      "SignIn",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onPressed: () {
                      _login(context);
                    },
                  ),
                ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  _login(context) async {
    Api api = new Api();
    setState(() {
      _isLoading = true;
    });
    var response = await api.post(
        jsonEncode(
          <String, dynamic>{
            "password": _passwordController.text,
            'me': widget.userId
          },
        ),
        'auth/signin');
    var token = jsonDecode(response.body);
    if (response.statusCode == 200) {
      await store.save('token', token);
      _isLoading = false;
      var nav = Navigator.of(context);
      nav.pop();
      nav.pop();
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _isLoading = false;
      showSnackbar(context, token['message']);
    }
    setState(() {});
  }

  _reset() {
    Navigator.push(context, SlideRightRoute(page: ForgetPassword()))
        .then((value) {
      if (value != null) {
        //
      }
    });
  }
}
