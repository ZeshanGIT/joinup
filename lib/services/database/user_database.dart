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
    return User.fromFirebaseUser(user);
  }

  User _userFromDocSnap(DocumentSnapshot snapshot) {
    print('Snapshot Data : ${snapshot.data}');
    return User.fromJson(snapshot.data);
  }

  Stream<User> getUserFromFirebaseUser() {
    print(uid);
    return _userCollection.document(uid).snapshots().map(_userFromDocSnap);
  }
}
