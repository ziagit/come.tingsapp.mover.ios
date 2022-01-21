import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shipbay/screens/auth/password.dart';
import 'package:shipbay/screens/auth/signup.dart';
import 'package:shipbay/screens/auth/verify.dart';
import 'package:shipbay/screens/home/home.dart';
import 'package:shipbay/shared/components/asset_image.dart';
import 'package:shipbay/shared/components/card_decoration.dart';
import 'package:shipbay/shared/components/input_decoration2.dart';
import 'package:shipbay/shared/components/simple_appbar.dart';
import 'package:shipbay/shared/components/slide_right_route.dart';
import 'package:shipbay/shared/components/snackbar.dart';
import 'package:shipbay/shared/functions/email_validator.dart';
import 'package:shipbay/shared/functions/phone_validator.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/colors.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
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

      // child: Text("This is where your content goes")
    );
  }

  Padding _buildPortraitLayout() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: cardDecoration(context),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: inputDecoration2(context, 'Email/phone'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ),
                      /* SizedBox(height: 10),
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            children: [
                              Text("Login using: "),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      SlideRightRoute(
                                          page:
                                              SocialLogin(provider: 'google')));
                                },
                                icon: Icon(
                                  Icons.mail,
                                  color: Colors.red[400],
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        SlideRightRoute(
                                            page: SocialLogin(
                                                provider: 'facebook')));
                                  },
                                  icon: Icon(Icons.facebook,
                                      color: Colors.blueAccent))
                            ],
                          )) */
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
          ),
        ],
      ),
    );
  }

  Padding _buildLandscapeLayout() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Email/phone'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
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
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
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
    if (isValidPhone(_emailController.text)) {
      String phone = '+1' + _emailController.text;
      _continue(phone);
    } else if (isValidEmail(_emailController.text)) {
      _continue(_emailController.text);
    } else {
      showSnackbar(context, "Please provide a valid email/phone");
    }
  }

  _continue(data) async {
    Api api = new Api();
    setState(() {
      _isLoading = true;
    });

    var response = await api.post(
        jsonEncode(
          <String, dynamic>{'email': data},
        ),
        'auth/check-email');
    var jsonData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (jsonData['role'] == 'mover') {
        setState(() {
          _isLoading = false;
        });
        if (jsonData['status'] == 'email') {
          Navigator.push(
              context, SlideRightRoute(page: Password(userId: jsonData['id'])));
        } else {
          Navigator.push(
                  context,
                  SlideRightRoute(
                      page: Verify(
                          phone: _emailController.text,
                          userId: jsonData['id'])))
              .then((value) {
            if (value != null) {
              Navigator.pushReplacement(context, SlideRightRoute(page: Home()));
            }
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        _errorSnackbar("The email/phone is not belongs to a mover account!");
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _errorSnackbar("${jsonDecode(response.body)}");
    }
  }

  _errorSnackbar(err) {
    final snackBar = SnackBar(content: Text("$err"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
