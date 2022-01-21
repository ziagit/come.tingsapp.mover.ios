import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shipbay/shared/components/asset_image.dart';
import 'package:shipbay/shared/components/card_decoration.dart';
import 'package:shipbay/shared/components/input_decoration2.dart';
import 'package:shipbay/shared/components/simple_appbar.dart';
import 'package:shipbay/shared/components/snackbar.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/colors.dart';

class NewPassword extends StatefulWidget {
  final email;
  const NewPassword({Key key, this.email}) : super(key: key);
  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmationController =
      TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar("New password"),
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
                        child: assetImage(context, "logo.png"),
                      ),
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
                          controller: _passwordController,
                          decoration: inputDecoration2(context, 'New password'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a valid password';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: cardDecoration(context),
                        child: TextFormField(
                          controller: _passwordConfirmationController,
                          decoration: inputDecoration2(
                              context, 'Password confirmation'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a valid password';
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
                              "Submit",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18),
                            ),
                            onPressed: () {
                              _submit(context);
                            },
                          ),
                        ),
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
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            labelText: 'New password'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a valid password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordConfirmationController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            labelText: 'Password confirmation'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a valid password';
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
                      "Submit",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                    onPressed: () {
                      _submit(context);
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

  _submit(context) async {
    if (_passwordController.text != _passwordConfirmationController.text) {
      showSnackbar(context, "Passwords not matching!");
      return null;
    }
    Api api = new Api();
    setState(() {
      _isLoading = true;
    });
    var response = await api.post(
        jsonEncode(
          <String, dynamic>{
            'email': widget.email,
            'password': _passwordController.text,
            'password_confirmation': _passwordConfirmationController.text
          },
        ),
        'password/reset');
    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      var data = jsonDecode(response.body);
      Navigator.pop(context, data['user']['id']);
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnackbar(context, "${jsonDecode(response.body)}");
    }
  }
}
