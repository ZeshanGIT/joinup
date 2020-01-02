import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class User {
  String uid, firstName, lastName, id, email, photoURL;

  User({
    @required this.uid,
    @required this.firstName,
    @required this.lastName,
    @required this.id,
    @required this.email,
    @required this.photoURL,
  });

  User.fromJson(Map<String, dynamic> user) {
    this.uid = user['uid'];
    this.firstName = user['firstName'];
    this.lastName = user['lastName'];
    this.email = user['email'];
    this.photoURL = user['photoUrl'];
  }

  User.fromFirebaseUser(FirebaseUser user) {
    this.uid = user.uid;
    this.firstName = user.displayName.split(' ')[0];
    this.lastName = user.displayName.split(' ').sublist(1).toString();
    this.email = user.email;
    this.photoURL = user.photoUrl;
  }
}
