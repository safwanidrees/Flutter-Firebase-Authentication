import 'package:firebase_authentication/auth_provider.dart';
import 'package:firebase_authentication/auth_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Are you sure you want to exit?',style: TextStyle(fontSize: 17),),
                actions: <Widget>[
                  FlatButton(
                    child: Text('No',style: TextStyle(color: Colors.purple),),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text('Yes, exit',style: TextStyle(color: Colors.purple),),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            });

        return value == true;
      },
      child: Scaffold(
          appBar: AppBar(
            leading: Container(),
            title: Text(
              "Home",
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: Center(
            child: InkWell(
              onTap: () {
                Provider.of<AuthProvider>(context, listen: false).signOut().then(
                    (_) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => AuthScreen()),
                        ModalRoute.withName("/")));
              },
              child: Container(
                margin: EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
                height: 50,
                width: double.infinity,
                color: Colors.white,
                child: Center(
                  child: Text(
                    "Logout",
                    style: TextStyle(
                        color: Colors.purple,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
