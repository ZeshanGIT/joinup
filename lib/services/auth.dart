import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:joinup/models/user_model.dart';
import 'package:joinup/services/database/user_database.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signOut() {
    _auth.signOut();
  }

  Future resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(
      email: email,
    );
  }

  Future googleSignIn() async {
    GoogleSignInAccount googleSignInAccount = await GoogleSignIn(scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
      'https://www.googleapis.com/auth/user.birthday.read'
    ]).signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    if (authResult != null) {
      if (authResult.additionalUserInfo.isNewUser) {
        UserDatabase().addUserFromFirebaseUser(authResult.user);
      }
    }
    return authResult;
  }

  void githubSignIn() async {
    const String url = "https://github.com/login/oauth/authorize" +
        "?client_id=" +
        GITHUB_CLIENT_ID +
        "&scope=public_repo%20read:user%20user:email";

    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      print("CANNOT LAUNCH THIS URL!");
    }
  }

  Future signInWithEmailAndPasssword(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future createUserWithEmailAndPassword(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser); 
  }

  User _userFromFirebaseUser(FirebaseUser event) {
    return User(
      email: event.email,
      firstName: event.displayName,
      lastName: '',
      id: event.displayName,
      photoURL: event.photoUrl,
      uid: event.uid,
    );
  }
}

const String GITHUB_CLIENT_ID = '06de8b3341e4c02fd405';
const String GITHUB_CLIENT_SECRET = '0c6edc947419a478ea4ed985277637118d590ed0';

Future loginWithGitHub(String code) async {
  final response = await http.post(
    "https://github.com/login/oauth/access_token",
    headers: {"Content-Type": "application/json", "Accept": "application/json"},
    body: jsonEncode(
      GitHubLoginRequest(
        clientId: GITHUB_CLIENT_ID,
        clientSecret: GITHUB_CLIENT_SECRET,
        code: code,
      ),
    ),
  );

  GitHubLoginResponse loginResponse =
      GitHubLoginResponse.fromJson(json.decode(response.body));

  print(loginResponse.scope);
  final AuthCredential credential = GithubAuthProvider.getCredential(
    token: loginResponse.accessToken,
  );

  final AuthResult user =
      await FirebaseAuth.instance.signInWithCredential(credential);
  return user;
}

class GitHubLoginRequest {
  String clientId;
  String clientSecret;
  String code;

  GitHubLoginRequest({this.clientId, this.clientSecret, this.code});

  dynamic toJson() => {
        "client_id": clientId,
        "client_secret": clientSecret,
        "code": code,
      };
}

class GitHubLoginResponse {
  String accessToken;
  String tokenType;
  String scope;

  GitHubLoginResponse({this.accessToken, this.tokenType, this.scope});

  factory GitHubLoginResponse.fromJson(Map<String, dynamic> json) =>
      GitHubLoginResponse(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        scope: json["scope"],
      );
}
