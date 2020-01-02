import 'package:flutter/material.dart';
import 'package:joinup/services/auth.dart';
import 'package:joinup/shared/constants.dart';
import 'package:joinup/shared/unfocus.dart';

class ResetPassword extends StatelessWidget {
  String _email = '';

  @override
  Widget build(BuildContext context) {
    return Unfocus(
      context,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Reset Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            child: Column(
              children: <Widget>[
                TextFormField(
                  onChanged: (val) => _email = val,
                  decoration: textFieldDecoration.copyWith(labelText: 'Email'),
                ),
                SizedBox(height: 32.0),
                PrimaryButton(
                  function: () {
                    AuthService().resetPassword(_email);
                  },
                  text: 'Reset password',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
