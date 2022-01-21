import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shipbay/shared/services/store.dart';
import 'package:shipbay/shared/services/settings.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class Api {
  Store _store = new Store();
  Future<http.Response> post(data, path) async {
    String token = await _store.read('token');
    try {
      var response = await http.post(
        Uri.parse('$baseUrl' + path),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: data,
      );
      return response;
    } catch (err) {
      return http.Response('Error: ${err.toString()}', 400);
    }
  }

  Future<http.Response> get(path) async {
    String token = await _store.read('token');
    try {
      var response = await http.get(
        Uri.parse('$baseUrl' + path),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );
      return response;
    } catch (err) {
      return http.Response('${err.toString()}', 400);
    }
  }

  Future<http.Response> update(data, path) async {
    String token = await _store.read('token');
    try {
      final response = await http.put(Uri.parse('$baseUrl' + path),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
          body: data);
      return response;
    } catch (err) {
      return http.Response('${err.toString()}', 400);
    }
  }

  Future<http.Response> google() async {
    try {
      var response = await http.get(
        Uri.parse('$baseUrl' + "auth/google"),
        headers: {'Content-Type': 'application/json'},
      );
      return response;
    } catch (err) {
      print('err: ${err.toString()}');
    }
    return null;
  }

  Future<http.Response> getFacebookProfile(token) async {
    try {
      var response = await http.get(Uri.parse(facebookUrl + token));
      return response;
    } catch (err) {
      return http.Response('${err.toString()}', 400);
    }
  }

  Future<Map<String, dynamic>> logout(context) async {
    String token = await _store.read('token');
    try {
      await http.post(Uri.parse('$baseUrl' + 'auth/signout'), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      });
      _signOutGoogle();
      _logOutFacebook();
      Navigator.of(context).pop();
    } catch (err) {
      print('err: ${err.toString()}');
    }
    return null;
  }

  _signOutGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
    await _googleSignIn.signOut();
    return null;
  }

  Future<Null> _logOutFacebook() async {
    //final FacebookLogin facebookSignIn = new FacebookLogin();
    //await facebookSignIn.logOut();
    return null;
  }

  Future uploadFile(file, path) async {
    String token = await _store.read('token');
    Dio dio = new Dio();
    dio.options.headers["Authorization"] = "Bearer $token";
    Response response = await dio.post(baseUrl + path, data: file);
    return response;
  }

  Future<http.Response> updateCalendar(data, path) async {
    String token = await _store.read('token');
    try {
      var response = await http.post(Uri.parse('$baseUrl' + path),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
          body: data);
      return response;
    } catch (err) {
      return http.Response('${err.toString()}', 400);
    }
  }

  Future<http.Response> searchJob(data, path) async {
    String token = await _store.read('token');
    try {
      var response = await http.post(Uri.parse('$baseUrl' + path),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
          body: data);
      return response;
    } catch (err) {
      return http.Response('${err.toString()}', 400);
    }
  }

  Future<http.Response> googleFindPlace(placeName, sessionToken) async {
    String autoComplete =
        "$googleApi?input=$placeName&types=address&components=country:ca&key=$mapKey&sessiontoken=$sessionToken";
    try {
      var response = await http.get(Uri.parse(autoComplete));
      return response;
    } catch (err) {
      return http.Response('${err.toString()}', 400);
    }
  }

  Future<http.Response> googleAddressDetails(placeId, sessionToken) async {
    String fields = 'address_component,formatted_address,geometry';
    String placeDetailsUrl =
        "$googleApiDetails?place_id=$placeId&fields=$fields&key=$mapKey&sessiontoken=$sessionToken";
    try {
      var response = await http.get(Uri.parse(placeDetailsUrl));
      return response;
    } catch (err) {
      return http.Response('${err.toString()}', 400);
    }
  }
}
