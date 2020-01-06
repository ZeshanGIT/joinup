import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:joinup/models/user_model.dart';

class UserDatabase {
  final String uid;

  UserDatabase({this.uid});

  CollectionReference _userCollection = Firestore.instance.collection('user');

  Future updateUser(Map<String, dynamic> data) async {
    await _userCollection.document(uid).setData(data, merge: true);
  }

  Future deleteUser() async {
    await _userCollection.document(uid).delete();
  }

  Stream<User> getUser() {
    return _userCollection.document(uid).snapshots().map(_userFromDocSnap);
  }

  Stream<bool> checkAvailabilty(String id) {
    return _userCollection
        .where('id', isEqualTo: id)
        .snapshots()
        .map((ss) => ss.documents.isEmpty);
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
      'id': null,
    };
    print('User Daaataaa  : ' + userData.toString());
    await _userCollection.document(user.uid).setData(userData);
    return User.fromFirebaseUser(user);
  }

  User _userFromDocSnap(DocumentSnapshot snapshot) {
    return User.fromJson(snapshot.data);
  }

  Stream<User> getUserFromFirebaseUser() {
    print(uid);
    return _userCollection.document(uid).snapshots().map(_userFromDocSnap);
  }
}
