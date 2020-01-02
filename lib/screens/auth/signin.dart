import 'package:flutter/material.dart';
import 'package:joinup/models/auth_models.dart';
import 'package:joinup/screens/auth/social_logins.dart';
import 'package:joinup/shared/constants.dart';

import 'package:joinup/services/auth.dart';
import 'package:joinup/shared/unfocus.dart';
import 'package:provider/provider.dart';

class SignIn extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _passFocusNode = FocusNode();
  String _email = '', _password = '';

  @override
  Widget build(BuildContext context) {
    final AuthenticateController _authController =
        Provider.of<AuthenticateController>(context);

    return Unfocus(
      context,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(_passFocusNode);
                    },
                    validator: emailIDValidator,
                    decoration:
                        textFieldDecoration.copyWith(labelText: 'Email'),
                    onChanged: (val) => _email = val,
                    autofocus: false,
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    focusNode: _passFocusNode,
                    onEditingComplete: () =>
                        singInHandler(context, _authController),
                    onChanged: (val) {
                      _password = val;
                    },
                    validator: (val) => val.length < 8
                        ? 'Must be atleast 8 characters long'
                        : null,
                    decoration:
                        textFieldDecoration.copyWith(labelText: 'Password'),
                    autofocus: false,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/resetPassword');
                      },
                      child: Text(
                        'Reset password',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  PrimaryButton(
                    text: 'Login',
                    function: () => singInHandler(context, _authController),
                  ),
                  SizedBox(height: 16),
                  FlatButton(
                    onPressed: () {
                      _authController.toggleSignIn();
                    },
                    child: Text(
                      'Don\'t have an account ?\nClick here to register',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SocialLogins()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  singInHandler(
    BuildContext context,
    AuthenticateController authenticateController,
  ) async {
    authenticateController.toggleLoading();
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      await AuthService().signInWithEmailAndPasssword(_email, _password);
      authenticateController.toggleLoading();
    }
  }

  String emailIDValidator(val) =>
      emailRegex.hasMatch(val) ? null : 'Invalid email';
}
