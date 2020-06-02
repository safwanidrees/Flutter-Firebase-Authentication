import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';



class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final Firestore firestore = Firestore.instance;

  String myUid;

  String errorMessage;

  User user = User();

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    myUid = currentUser.uid;
    notifyListeners();

    return currentUser;
  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    QuerySnapshot result = await firestore
        .collection("users")
        .where("email", isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(FirebaseUser currentUser) async {
    user = User(
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        profilePhoto: currentUser.photoUrl,
        username: currentUser.email,
       );

    await firestore
        .collection("users")
        .document(currentUser.uid)
        .setData(user.toMap(user));

    notifyListeners();
  }

  Future<FirebaseUser> SignInManually(String email, String password) async {
    BuildContext context;
    try {
      AuthResult SingInuser = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser _user = SingInuser.user;
      notifyListeners();

      return _user;
    } on PlatformException catch (e) {

      if (Platform.isAndroid) {
        errorMessage = e.message.toString();
      } else if (Platform.isIOS) {
        errorMessage = e.message.toString();
      }
    }
  }

  Future<FirebaseUser> SignUpManually(String email, String password) async {
    try {
      AuthResult SingUpuser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser _user = SingUpuser.user;
      notifyListeners();
      return _user;
    } on PlatformException catch (e) {
      if (Platform.isAndroid) {
        errorMessage = e.message.toString();
      } else if (Platform.isIOS) {
        errorMessage = e.message.toString();
      }
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<FirebaseUser> googlesSignIn() async {
    FirebaseUser currentUser;
    try {
      GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication _signInAuthentication =
          await _signInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: _signInAuthentication.accessToken,
          idToken: _signInAuthentication.idToken);

      AuthResult user = await _auth.signInWithCredential(credential);
      FirebaseUser _user = user.user;
      currentUser = _user;
      notifyListeners();

      return currentUser;
    } on PlatformException catch (e) {
      if (Platform.isAndroid) {
        errorMessage = e.message.toString();
      } else if (Platform.isIOS) {
        errorMessage = e.message.toString();
      }
      return currentUser;
    }
  }

  Future<FirebaseUser> facebookLogin() async {
    FirebaseUser currentUser;
    var fbLogin = FacebookLogin();

    fbLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;

    try {
      final FacebookLoginResult facebookLoginResult =
          await fbLogin.logIn(['email', 'public_profile']);
      if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
        FacebookAccessToken facebookAccessToken =
            facebookLoginResult.accessToken;
        final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: facebookAccessToken.token);
        final AuthResult user = await _auth.signInWithCredential(credential);
        assert(user.user.email != null);
        assert(user.user.displayName != null);
        assert(!user.user.isAnonymous);
        assert(await user.user.getIdToken() != null);
        currentUser = await _auth.currentUser();
        assert(user.user.uid == currentUser.uid);
        return currentUser;
      }
    } on PlatformException catch (e) {
      if (Platform.isAndroid) {
        errorMessage = e.message.toString();
      } else if (Platform.isIOS) {
        errorMessage = e.message.toString();
      }

      return currentUser;
    }
  }
}
