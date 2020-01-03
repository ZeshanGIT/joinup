import 'package:flutter/material.dart';
import 'package:joinup/models/user_model.dart';
import 'package:joinup/services/auth.dart';
import 'package:joinup/services/database/user_database.dart';

class Home extends StatelessWidget {
  final String uid;
  Home(this.uid);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: UserDatabase(uid: uid).getUserFromFirebaseUser(),
      builder: (_, ss) {
        if (ss.hasData)
          return Scaffold(
            body: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      AuthService().signOut();
                    },
                    child: Text(ss.data.firstName ?? 'Null'),
                  ),
                  FlatButton(
                    onPressed: () {
                      AuthService().deleteAccount(uid);
                    },
                    child: Text(ss.data.firstName ?? 'Null'),
                  ),
                ],
              ),
            ),
          );
        else {
          return Column(
            children: <Widget>[
              Text('Something went wrong !'),
              FlatButton(
                onPressed: () {
                  AuthService().signOut();
                },
                child: Text('Try Again'),
              ),
            ],
          );
        }
      },
    );
  }
}
