import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:joinup/models/user_model.dart';
import 'package:joinup/services/auth.dart';
import 'package:joinup/services/database/user_database.dart';
import 'package:joinup/shared/constants.dart';

class RegisterExtended extends StatefulWidget {
  @override
  _RegisterExtendedState createState() => _RegisterExtendedState();
}

class _RegisterExtendedState extends State<RegisterExtended> {
  final _formKey = GlobalKey<FormState>();
  String id = '';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: AuthService().user,
      builder: (_, snapShot) => StreamBuilder(
        stream: UserDatabase(uid: snapShot.data.uid).getUser(),
        builder: (_, ss) => Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('Register'),
          ),
          body: Form(
            key: _formKey,
            child: PageView(
              children: <Widget>[
                _buildBasicInfoPage(ss.data),
              ]
                  .map(
                    (child) => Padding(
                      padding: EdgeInsets.all(32),
                      child: child,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  _buildBasicInfoPage(User user) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 128,
              width: 128,
              decoration: BoxDecoration(
                color: Colors.pink,
                image: DecorationImage(image: NetworkImage(user.photoURL)),
                borderRadius: BorderRadius.circular(100),
              ),
              alignment: Alignment.bottomRight,
            ),
          ),
          SizedBox(height: 32),
          TextFormField(
            decoration: textFieldDecoration.copyWith(labelText: 'First Name'),
            initialValue: user.firstName ?? '',
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: textFieldDecoration.copyWith(labelText: 'Last Name'),
            initialValue: user.lastName ?? '',
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: textFieldDecoration.copyWith(labelText: 'Email'),
            initialValue: user.email ?? '',
          ),
          SizedBox(height: 16),
          TextFormField(
            onChanged: (val) => setState(() => id = val),
            decoration: textFieldDecoration.copyWith(labelText: 'ID'),
            initialValue: user.id ?? '',
          ),
          SizedBox(height: 16),
          StreamBuilder<bool>(
            stream: UserDatabase().checkAvailabilty(id),
            builder: (_, ss) => Container(
                width: double.maxFinite,
                color: Colors.red,
                child: Text(ss.data ? 'Available' : 'Not available')),
          ),
        ],
      ),
    );
  }
}
