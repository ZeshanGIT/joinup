import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:joinup/models/user_model.dart';

class UserDatabase {
  final String uid;

  UserDatabase({this.uid});

  CollectionReference _userCollection = Firestore.instance.collection('user');

  Future<User> addUserFromFirebaseUser(FirebaseUser user) async {
    final userData = {
      'profileComplete': false,
      'uid': user.uid,
      'photoUrl': user.photoUrl,
      'firstName': user.displayName.split(' ').first,
      'lastName': user.displayName.substring(user.displayName.indexOf(' ')),
      'email': user.email,
      'phoneNumber': user.phoneNumber,
    };
    print('User Daaataaa  : ' + userData.toString());
    await _userCollection.document(user.uid).setData(userData);
    return User.fromFirebaseUser(user);
  }
}
