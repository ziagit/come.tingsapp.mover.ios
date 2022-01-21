import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shipbay/screens/auth/new_password.dart';
import 'package:shipbay/screens/auth/reset_password.dart';
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

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar('Forget password'),
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
                          decoration: inputDecoration2(
                              context, 'Enter your email or phone'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
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
              child: _isLoading
                  ? CircularProgressIndicator(backgroundColor: Tingsapp.grey)
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 60.0,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                          ),
                        ),
                        child: Text(
                          "Send",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 18),
                        ),
                        onPressed: () {
                          _send(context);
                        },
                      ),
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
                        labelText: 'Enter your email or phone'),
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
                      "Send",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                    onPressed: () {
                      _send(context);
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

  _send(context) async {
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
        'password/forget');
    var jsonData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      Navigator.push(context,
              SlideRightRoute(page: ResetPassword(email: jsonData['email'])))
          .then((value) {
        if (value != null) {
          Navigator.push(
                  context, SlideRightRoute(page: NewPassword(email: value)))
              .then((value) {
            if (value != null) {
              Navigator.of(context).pop();
            }
          });
        }
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnackbar(context, "${jsonDecode(response.body)}");
    }
  }
}

//new password
