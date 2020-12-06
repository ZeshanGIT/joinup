import 'package:flutter/material.dart';
import 'package:joinup/models/user_model.dart';
import 'package:joinup/shared/constants.dart';

class SecondaryInfo extends StatefulWidget {
  final PageController pageController;
  final User user;
  const SecondaryInfo(this.user, this.pageController);

  @override
  _SecondaryInfoState createState() =>
      _SecondaryInfoState(user, pageController);
}

class _SecondaryInfoState extends State<SecondaryInfo> {
  final _formKey = GlobalKey<FormState>();

  final User user;

  final PageController pageController;
  _SecondaryInfoState(this.user, this.pageController);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 16),   
            TextFormField(
              readOnly: true,
              onTap: () async {
                dynamic val = Navigator.of(context).pushNamed('/chooseTitle');
                print(val);
              },
              decoration: textFieldDecoration.copyWith(labelText: 'Title'),
            ),
          ],
        ),
      ),
    );
  }
}
