import 'dart:async';

import 'package:flutter/material.dart';
import 'package:joinup/models/auth_models.dart';

import 'package:joinup/screens/auth/signin.dart';
import 'package:joinup/screens/auth/register.dart';
import 'package:joinup/services/auth.dart';
import 'package:joinup/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  StreamSubscription _subs;

  @override
  void initState() {
    _initDeepLinkListener();
    super.initState();
  }

  @override
  void dispose() {
    _disposeDeepLinkListener();
    
    super.dispose();
  }

  void _initDeepLinkListener() async {
    _subs = getLinksStream().listen((String link) {
      _checkDeepLink(link);
    }, cancelOnError: true);
  }

  void _checkDeepLink(String link) async {
    if (link != null) {
      String code = link.substring(link.indexOf(RegExp('code=')) + 5);
      print('Code from Authenticate : $code');
      await loginWithGitHub(code, context);
    }
  }

  void _disposeDeepLinkListener() {
    if (_subs != null) {
      _subs.cancel();
      _subs = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthenticateController authenticateController =
        Provider.of<AuthenticateController>(context);
    return Stack(
      children: <Widget>[
        authenticateController.isLoading
            ? Align(
                alignment: Alignment.center,
                child: Container(
                  height: 250,
                  width: 250,
                  color: Colors.black45,
                  child: Loading(),
                ),
              )
            : Container(),
        (authenticateController.showSignIn ? SignIn() : Register()),
      ],
    );
  }
}
