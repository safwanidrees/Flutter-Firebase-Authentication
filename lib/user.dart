import 'package:flutter/material.dart';

class User {
  final String uid;
  final String name;
  final String email;
  final String username;
  final String profilePhoto;

  User({
    @required this.uid,
    @required this.name,
    @required this.email,
    @required this.username,
    @required this.profilePhoto,
  });

  Map toMap(User user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['name'] = user.name;
    data['email'] = user.email;
    data['username'] = user.username;
    data["profile_photo"] = user.profilePhoto;

    return data;
  }
}
