import 'package:flutter/material.dart';
import 'package:joinup/models/auth_models.dart';
import 'package:joinup/screens/auth/social_logins.dart';
import 'package:joinup/shared/constants.dart';
import 'package:joinup/shared/unfocus.dart';
import 'package:password_strength/password_strength.dart';

import 'package:joinup/services/auth.dart';
import 'dart:math';

import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  // final Function toggleSignIn;

  // Register(this.toggleSignIn);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _passFocusNode = FocusNode();

  double strength = 0.0;
  String _email = '', _password = '';
  ScrollController _scrollController = ScrollController();
  bool showStrength = false;

  @override
  Widget build(BuildContext context) {
    final AuthenticateController _authController =
        Provider.of<AuthenticateController>(context);
    return Unfocus(
      context,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
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
                    onTap: () {
                      setState(() {
                        showStrength = true;
                      });
                      _scrollController.animateTo(
                        48,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                      );
                    },
                    focusNode: _passFocusNode,
                    onEditingComplete: registerHandler,
                    onChanged: (val) {
                      setState(() {
                        _password = val;
                        strength = estimatePasswordStrength(val);
                      });
                      // print(strength);
                    },
                    validator: (val) => val.length < 8
                        ? 'Must be atleast 8 characters long'
                        : null,
                    decoration:
                        textFieldDecoration.copyWith(labelText: 'Password'),
                    autofocus: false,
                  ),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 200),
                    child: showStrength
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 16),
                              Container(
                                width: double.maxFinite,
                                child: Text('Password Strength'),
                              ),
                              SizedBox(height: 8),
                              buildPasswordStrength(),
                            ],
                          )
                        : Container(),
                  ),
                  SizedBox(height: 48),
                  PrimaryButton(
                    text: 'Register',
                    function: registerHandler,
                  ),
                  SizedBox(height: 16),
                  FlatButton(
                    onPressed: () {
                      _authController.toggleSignIn();
                    },
                    child: Text(
                      'Already have an account?\nClick here to login',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SocialLogins(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPasswordStrength() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          alignment: Alignment.centerLeft,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32.0),
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              print(constraints.maxWidth * (min(_password.length, 8) / 8));
              return AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: 8,
                width: constraints.maxWidth * (min(_password.length, 8) / 8),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 2.0,
                      blurRadius: 8.0,
                      offset: Offset.zero,
                      color: Color.lerp(
                        Colors.pink[300].withAlpha(75),
                        Colors.pink[900].withAlpha(75),
                        strength,
                      ),
                    )
                  ],
                  color: Color.lerp(
                    Colors.pink[300],
                    Colors.pink[900],
                    strength,
                  ),
                  borderRadius: BorderRadius.circular(32.0),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  registerHandler() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      AuthService().createUserWithEmailAndPassword(_email, _password);
    }
  }

  String emailIDValidator(val) =>
      emailRegex.hasMatch(val) ? null : 'Invalid email';
}

// gradient: LinearGradient(
//   colors: [

//     Color.lerp(
//       Colors.pink[300],
//       Colors.pink[900],
//       strength,
//     ),
//     Colors.white,
//     Colors.white,
//   ],
//   stops: [
//     0,
//     min(_password.length / 8, 8),
//     min(_password.length / 8, 8),
//     1.0,
//   ],
// ),
// color:
//     ,
