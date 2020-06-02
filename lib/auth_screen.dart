
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/auth_provider.dart';
import 'package:firebase_authentication/home_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  static const String routeName = "/user_auth_Screen";

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  var errorMessage;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  bool _isLoading = false;
  final _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
//    errorMessage =
//        Provider.of<AuthProvider>(context, listen: false).errorMessage;
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  void _showerrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'An Error Occurs',
          style: TextStyle(color: Colors.orange),
        ),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isLoading = false;
              });
            },
          )
        ],
      ),
    );
  }

  Future _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }

    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // await Provider.of<Auth>(context, listen: false)
        //     .login(_authData['email'], _authData['password']);
        // Log user in
        Provider.of<AuthProvider>(context, listen: false)
            .SignInManually(_authData['email'], _authData['password'])
            .then((FirebaseUser user) {
          if (user != null) {
//            print(user.email);

            authenticateUser(user);
          } else {
            switch (Provider.of<AuthProvider>(context, listen: false)
                .errorMessage) {
              case 'There is no user record corresponding to this identifier. The user may have been deleted.':
                _showerrorDialog("No User Found");

                break;
              case 'Error 17011':
                _showerrorDialog("No User Found");

                break;
              case 'The password is invalid or the user does not have a password.':
                _showerrorDialog("Invalid Password");
                break;

              case 'Error 17009':
                _showerrorDialog("Invalid Password");
                break;

              case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
                _showerrorDialog("Network Problem");
                break;

              case 'Error 17020':
                _showerrorDialog("Network Problem");
                break;
              // ...
              default:
                _showerrorDialog("An error Occurs");
            }
          }
        });
      } else {
//        print(_authData['password']);
//
//        print("tring to perform login");
        Provider.of<AuthProvider>(context, listen: false)
            .SignUpManually(_authData['email'], _authData['password'])
            .then((FirebaseUser user) {
          print("something");
          if (user != null) {
//            print(user.email);

            authenticateUser(user);
          } else {
            switch (Provider.of<AuthProvider>(context, listen: false)
                .errorMessage) {
              case 'The email address is already in use by another account.':
                _showerrorDialog("Account already in use");

                break;
              case 'Error 17011':
                _showerrorDialog("No User Found");

                break;
              default:
                _showerrorDialog("An error Occurs");
            }
          }
        });
      }

      // );

    } catch (e) {}
    // }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontSize: 20.0, color: Colors.black);
    return WillPopScope(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  left: 20,
                  top: MediaQuery.of(context).size.height * 0.09,
                  right: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Welcome \nUser',
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${_authMode == AuthMode.Login ? 'Login' : 'Sign up'} to join',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 15.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0))),
                          child: TextFormField(
                            style: style,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.black),
                              hintText: 'Email',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value.isEmpty || !value.contains('@')) {
                                return 'Invalid email!';
                              }
                            },
                            onSaved: (value) {
                              _authData['email'] = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 15.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0))),
                          child: TextFormField(
                            style: style,
                            obscureText: true,
                            controller: _passwordController,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.black),
                              hintText: 'Password',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value.isEmpty || value.length < 5) {
                                return 'Password is too short!';
                              }
                            },
                            onSaved: (value) {
                              _authData['password'] = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        if (_authMode == AuthMode.Signup)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 15.0),
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(50.0))),
                                child: TextFormField(
                                  style: style,
                                  obscureText: true,
                                  enabled: _authMode == AuthMode.Signup,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(color: Colors.black),
                                    hintText: 'Confirm Password',
                                    border: InputBorder.none,
                                  ),
                                  validator: _authMode == AuthMode.Signup
                                      ? (value) {
                                          if (value !=
                                              _passwordController.text) {
                                            return 'Passwords do not match!';
                                          }
                                        }
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        SizedBox(
                          height: 30,
                        ),
                        _isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : InkWell(
                                onTap: () => _submit(),
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  height: 50,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Colors.purple,
                                        Colors.purple,
                                        Colors.pink,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _authMode == AuthMode.Login
                                          ? 'LOGIN'
                                          : 'SIGN UP',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '${_authMode == AuthMode.Login ? 'You are not member?' : 'Do have an account?'}',
                            ),
                            InkWell(
                              onTap: () {
                                // Navigator.of(context).pushReplacement(
                                //     MaterialPageRoute(builder: (ctx) => LoginScreen()));
                                _switchAuthMode();
                              },
                              child: Container(
                                child: Text(
                                  ' ${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: _authMode == AuthMode.Login
                        ? MediaQuery.of(context).size.height * 0.12
                        : MediaQuery.of(context).size.height * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        width: 140,
                        child: RaisedButton.icon(
                          onPressed: () {
                            performGoogleLogin();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          icon: Icon(
                            FontAwesomeIcons.google,
                            color: Colors.red,
                            size: 20,
                          ),
                          label: Text('Google'),
                          color: Colors.white,
                          elevation: 1,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        width: 140,
                        child: RaisedButton.icon(
                          onPressed: () {
                            performFbLogin();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          icon: Icon(
                            FontAwesomeIcons.facebookF,
                            color: Colors.blue,
                            size: 20,
                          ),
                          label: Text('Facebook'),
                          color: Colors.white,
                          elevation: 1,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }

  void performFbLogin() {
    setState(() {
      _isLoading = true;
    });
    print("tring to perform login");
    Provider.of<AuthProvider>(context, listen: false)
        .facebookLogin()
        .then((FirebaseUser user) {
      print("something");
      if (user != null) {
        authenticateUser(user);
      } else {
        switch (
            Provider.of<AuthProvider>(context, listen: false).errorMessage) {
          case 'The email address is already in use by another account.':
            _showerrorDialog("Account already in use");

            break;
          case 'Error 17011':
            _showerrorDialog("No User Found");

            break;
          default:
            _showerrorDialog("An error Occurs");
        }
      }
    });
  }

  void performGoogleLogin() {
    setState(() {
      _isLoading = true;
    });
    print("tring to perform login");
    Provider.of<AuthProvider>(context, listen: false)
        .googlesSignIn()
        .then((FirebaseUser user) {
      print("something");

      if (user != null) {
        authenticateUser(user);
      } else {
        switch (
            Provider.of<AuthProvider>(context, listen: false).errorMessage) {
          case 'The email address is already in use by another account.':
            _showerrorDialog("Account already in use");

            break;
          case 'Error 17011':
            _showerrorDialog("No User Found");

            break;
          default:
            _showerrorDialog("An error Occurs");
        }
      }
    });
  }

  void authenticateUser(FirebaseUser user) {
    Provider.of<AuthProvider>(context, listen: false)
        .authenticateUser(user)
        .then((isNewUser) {
      if (isNewUser) {
        Provider.of<AuthProvider>(context, listen: false)
            .addDataToDb(user)
            .then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
        });
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      }
    });
  }
}
