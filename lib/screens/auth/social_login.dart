/* import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shipbay/moving/models/user.dart';
import 'package:shipbay/moving/pages/home/home.dart';
import 'package:shipbay/moving/pages/profile/add_profile.dart';
import 'package:shipbay/shared/components/slide_right_route.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/store.dart';

class SocialLogin extends StatefulWidget {
  final provider;
  const SocialLogin({Key key, this.provider}) : super(key: key);

  @override
  _SocialLoginState createState() => _SocialLoginState();
}

class _SocialLoginState extends State<SocialLogin> {
  Store _store = Store();
  bool _isLogedIn = false;
  bool _isLoading = false;
  User _user;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  //facebook
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  @override
  void initState() {
    _signIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login using ' + widget.provider ?? ''),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: _isLoading
                ? CircularProgressIndicator(backgroundColor: Tingsapp.grey)
                : Container(
                    child: _isLogedIn
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Text("You are loged in!"),
                                TextButton(
                                  child: Text("Complete the registeration"),
                                  onPressed: () => _completeRegisteration(),
                                )
                              ])
                        : Container()),
          ),
        ),
      ),
    );
  }

  _signIn() {
    switch (widget.provider) {
      case 'google':
        _google();
        break;
      case 'facebook':
        _facebook();
        break;
      default:
        print("No provider");
    }
  }

//google
  _google() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _googleSignIn.signIn();
      await _register(_googleSignIn.currentUser.displayName,
          _googleSignIn.currentUser.email, widget.provider);
    } catch (err) {
      print(err);
    }
  }

  //facebook login
  Future<Null> _facebook() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        _getFacebookDetails(accessToken.token);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("Login canceled by user");
        break;
      case FacebookLoginStatus.error:
        _snackBarError(result.errorMessage);
        break;
    }
  }

  _getFacebookDetails(token) async {
    setState(() {
      _isLoading = true;
    });
    Api api = new Api();
    var response = await api.getFacebookProfile(token);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      _register(jsonData['name'], jsonData['email'], widget.provider);
    } else {
      String error = "Faild to get Facebook details, please try again";
      _snackBarError(error);
    }
  }

  _snackBarError(error) {
    final snackBar = SnackBar(
      content: Text("$error"),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _register(name, email, provider) async {
    Api api = new Api();
    var response = await api.post(
        jsonEncode(<String, dynamic>{
          "name": name,
          "email": email,
          "provider": provider,
          "type": 'mover',
        }),
        "auth/mobile/signin");
    var jsonData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      _store.save('token', jsonData);
      var me = await api.get('auth/me');
      if (me.statusCode == 200) {
        var jsonUser = jsonDecode(me.body);
        _user = User(jsonUser['id'], jsonUser['avatar'], jsonUser['name'],
            jsonUser['email'], jsonUser['phone'], '', '');
        if (_user.email == null || _user.phone == null) {
          setState(() {
            _isLoading = false;
            _isLogedIn = true;
          });
        } else {
          Navigator.pushReplacement(context, SlideRightRoute(page: Home()));
        }
      }
      return;
    }
    return;
  }

  _completeRegisteration() {
    Navigator.push(context, SlideRightRoute(page: AddProfile(user: _user)))
        .then((value) {
      if (value != null) {
        Navigator.pushReplacement(context, SlideRightRoute(page: Home()));
      }
    });
  }
}
 */