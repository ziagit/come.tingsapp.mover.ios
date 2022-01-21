import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:shipbay/shared/components/asset_image.dart';
import 'package:shipbay/shared/components/simple_appbar.dart';
import 'package:shipbay/shared/components/snackbar.dart';
import 'package:shipbay/shared/functions/phone_validator.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shared/services/store.dart';

class Verify extends StatefulWidget {
  final phone;
  final userId;
  const Verify({Key key, this.phone, this.userId}) : super(key: key);

  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  bool _isLoading = false;
  Store _store = Store();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.black54),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar("Verify"),
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
      var nav = Navigator.of(context);
      nav.pop();
      nav.pop();
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _isLoading = false;
      showSnackbar(context, "${jsonDecode(response.body)}");
    }
    setState(() {});
  }
}
