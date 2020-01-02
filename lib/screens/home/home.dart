import 'package:flutter/material.dart';
import 'package:joinup/models/user_model.dart';
import 'package:joinup/services/auth.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: AuthService().user,
      builder: (_, ss) {
        if (ss.hasData)
          return Scaffold(
            body: Container(
              alignment: Alignment.center,
              child: RaisedButton(
                onPressed: () {
                  AuthService().signOut();
                },
                child: Text(ss.data.firstName),
              ),
            ),
          );
        else
          return Container();
      },
    );
  }
}
