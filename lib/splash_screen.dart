import 'dart:async';

import 'package:firebase_authentication/auth_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), route);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  route() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => AuthScreen()));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Text(
          "Firebase Authentication",
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
    );
  }
}
