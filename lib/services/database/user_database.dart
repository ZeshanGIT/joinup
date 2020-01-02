import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
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

    try {
      final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
        functionName: 'addNewUser',
      );
      HttpsCallableResult resp = await callable.call(<String, dynamic>{
        'uid': user.uid,
      });
      print('Resp Data : ${resp.data}');
    } catch (e) {
      print(e);
    }
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
