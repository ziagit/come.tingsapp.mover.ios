import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shipbay/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Routes());
}
