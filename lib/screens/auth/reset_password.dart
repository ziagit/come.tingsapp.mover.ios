import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shipbay/shared/components/asset_image.dart';
import 'package:shipbay/shared/components/simple_appbar.dart';
import 'package:shipbay/shared/components/snackbar.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:pinput/pin_put/pin_put.dart';

class ResetPassword extends StatefulWidget {
  final email;
  const ResetPassword({Key key, this.email}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  bool _isLoading = false;

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.black54),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar("Reset password"),
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
              "We texted a code to " + widget.email,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: _isLoading
                  ? CircularProgressIndicator(backgroundColor: Tingsapp.grey)
                  : Container()),
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
                "We texted a code to " + widget.email,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              _isLoading
                  ? CircularProgressIndicator(backgroundColor: Tingsapp.grey)
                  : Container()
            ],
          )
        ],
      ),
    );
  }

  void _verify(String pin, BuildContext context) async {
    Api api = new Api();
    setState(() {
      _isLoading = true;
    });
    var response = await api.post(
        jsonEncode(
          <String, dynamic>{"code": pin, "email": widget.email},
        ),
        'password/verify');
    if (response.statusCode == 200) {
      _isLoading = false;
      Navigator.pop(context, widget.email);
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnackbar(context, "${jsonDecode(response.body)}");
    }
  }
}
