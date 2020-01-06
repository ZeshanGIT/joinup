import 'package:flutter/material.dart';
import 'package:joinup/models/user_model.dart';
import 'package:joinup/screens/auth/register/basic_info.dart';
import 'package:joinup/screens/auth/register/secondary_info.dart';
import 'package:joinup/services/auth.dart';
import 'package:joinup/services/database/user_database.dart';

class RegisterExtended extends StatefulWidget {
  @override
  _RegisterExtendedState createState() => _RegisterExtendedState();
}

class _RegisterExtendedState extends State<RegisterExtended> {
  String id = '';
  bool startAutoValidate = false;
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: AuthService().user,
      builder: (_, snapShot) => StreamBuilder<User>(
        stream: UserDatabase(uid: snapShot.data.uid).getUser(),
        builder: (_, ss) {
          print('Snapshot Data : ${ss.data}');
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text('Register'),
              ),
              body: PageView(
                controller: pageController,
                children: <Widget>[
                  BasicInfo(ss.data, pageController),
                  SecondaryInfo(ss.data, pageController),
                ]
                    .map(
                      (child) => Padding(
                        child: child,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
