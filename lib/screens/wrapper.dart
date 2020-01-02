import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:joinup/models/auth_models.dart';
import 'package:joinup/models/user_model.dart';
import 'package:joinup/shared/noconnection.dart';
import 'package:provider/provider.dart';

import 'package:joinup/services/auth.dart';
import 'package:joinup/screens/auth/authenticate.dart';
import 'package:joinup/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConnectivityResult _connectivityResult =
        Provider.of<ConnectivityResult>(context);

    return _connectivityResult == ConnectivityResult.none
        ? NoConnection()
        : StreamBuilder<User>(
            stream: AuthService().user,
            builder: (bc, usr) {
              return usr.data == null
                  ? ChangeNotifierProvider<AuthenticateController>.value(
                      value: AuthenticateController(),
                      child: Authenticate(),
                    )
                  : Home();
            },
          );
  }
}
