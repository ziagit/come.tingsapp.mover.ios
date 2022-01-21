import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shipbay/screens/auth/signin.dart';
import 'package:shipbay/screens/auth/signup.dart';
import 'package:shipbay/shared/components/asset_image.dart';
import 'package:shipbay/shared/components/slide_right_route.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(height: 40),
                Container(
                  child: Column(
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
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
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
                            Navigator.push(
                                context, SlideRightRoute(page: Signin()));
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Want to be a mover?",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
