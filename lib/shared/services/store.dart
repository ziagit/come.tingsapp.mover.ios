import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Store {
  read(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      return json.decode(prefs.getString(key));
    } else {
      return null;
    }
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  check(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key) ? true : false;
  }
}
