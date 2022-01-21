import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shipbay/shared/components/simple_appbar.dart';
import 'package:shipbay/shared/components/snackbar.dart';
import 'package:shipbay/shared/functions/email_validator.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shared/services/store.dart';

class EditAccount extends StatefulWidget {
  final user;
  EditAccount({Key key, this.user}) : super(key: key);
  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  Store store = Store();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isPassword = false;
  bool _isSubmiting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: SimpleAppBar("Edit account"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Email'),
                    style: TextStyle(fontSize: 12.0),
                  ),
                  SizedBox(height: 18),
                  Row(
                    children: [
                      Switch(
                          value: _isPassword,
                          onChanged: (value) {
                            setState(() {
                              _isPassword = value;
                            });
                          }),
                      Text("Change password?")
                    ],
                  ),
                  SizedBox(height: 18),
                  _isPassword
                      ? TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                              labelText: 'Password'),
                          style: TextStyle(fontSize: 12.0),
                        )
                      : Container(),
                  SizedBox(height: 24.0),
                  _isPassword
                      ? TextFormField(
                          controller: _passwordConfirmController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                              labelText: 'Confirm password'),
                          style: TextStyle(fontSize: 12.0),
                        )
                      : Container(),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _isSubmiting
          ? CircularProgressIndicator(backgroundColor: Tingsapp.grey)
          : FloatingActionButton(
              child: Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _update();
                }
              },
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    setState(() {
      _emailController.text = widget.user.email;
    });
  }

  _update() async {
    Api api = new Api();
    if (isValidEmail(_emailController.text)) {
      setState(() {
        _isSubmiting = true;
      });
      var response = await api.update(
          jsonEncode(<String, dynamic>{
            "email": _emailController.text,
            "password": _passwordController.text,
            "password_confirmation": _passwordConfirmController.text,
          }),
          "carrier/account/${widget.user.id}");
      if (response.statusCode == 200) {
        setState(() {
          _isSubmiting = false;
        });
        Navigator.pop(context, 'updated');
      } else {
        showSnackbar(context, "${jsonDecode(response.body)}");
      }
    } else {
      showSnackbar(context, "Invalid email");
    }
  }
}
