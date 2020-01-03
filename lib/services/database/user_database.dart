import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:joinup/models/user_model.dart';

class UserDatabase {
  final String uid;

  UserDatabase({this.uid});

  CollectionReference _userCollection = Firestore.instance.collection('user');

  Future deleteUser() async {
    await _userCollection.document(uid).delete();
  }

  Future<void> getUser() async {
    DocumentSnapshot dss = await _userCollection.document(uid).get();
    print('Doc exists ? : ${dss.exists}');
  }

  Future<User> addUserFromFirebaseUser(FirebaseUser user) async {
    final userData = {
      'profileComplete': false,
      'uid': user.uid,
      'photoUrl': user.photoUrl,
      'firstName': user.displayName.split(' ').first,
      'lastName': user.displayName.split(' ').length == 2
          ? user.displayName.split(' ')[1]
          : '',
      'email': user.email,
      'phoneNumber': user.phoneNumber,
    };
    print('User Daaataaa  : ' + userData.toString());
    await _userCollection.document(user.uid).setData(userData);
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
