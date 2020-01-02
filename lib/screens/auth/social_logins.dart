import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joinup/services/auth.dart';

class SocialLogins extends StatelessWidget {
  const SocialLogins({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            onPressed: () async {
              AuthResult _authResult = await AuthService().googleSignIn();
              if (_authResult != null) if (_authResult
                  .additionalUserInfo.isNewUser) {
                // Navigator.of(context).popAndPushNamed('/newUser/gsignin');
              } else
                print('Old Useeeeeeeeer');
            },
            icon: SvgPicture.asset(
              'assets/icons/google.svg',
            ),
          ),
          IconButton(
            onPressed: () {
              AuthService().githubSignIn();
            },
            icon: SvgPicture.asset(
              'assets/icons/ghub.svg',
              width: 100,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
