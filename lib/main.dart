import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:joinup/screens/auth/register/register_extended.dart';
import 'package:joinup/screens/auth/register/search_title.dart';
import 'package:joinup/screens/auth/reset_password.dart';
import 'package:provider/provider.dart';
import 'screens/wrapper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<ConnectivityResult>.value(
      value: Connectivity().onConnectivityChanged,
      child: MaterialApp(
        theme: ThemeData(
          cursorColor: Colors.pink,
          primaryColor: Colors.pink,
          fontFamily: 'JS',
        ),
        routes: {
          '/': (_) => Wrapper(),
          '/resetPassword': (_) => ResetPassword(),
          '/registerExtended': (_) => RegisterExtended(),
          '/chooseTitle': (_) => ChooseTitle(),
        },
      ),
    );
  }
}
