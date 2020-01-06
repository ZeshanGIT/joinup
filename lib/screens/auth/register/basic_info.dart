import 'package:flutter/material.dart';
import 'package:joinup/models/user_model.dart';
import 'package:joinup/services/database/user_database.dart';
import 'package:joinup/shared/constants.dart';
import 'package:joinup/shared/loading.dart';

class BasicInfo extends StatefulWidget {
  User user;
  PageController pageController;

  BasicInfo(this.user, this.pageController);

  @override
  _BasicInfoState createState() => _BasicInfoState(user, pageController);
}

class _BasicInfoState extends State<BasicInfo> {
  ScrollController scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool startAutoValidate = false, autoValidate = false;
  User user;

  PageController pageController;
  _BasicInfoState(this.user, this.pageController);

  @override
  Widget build(BuildContext context) {
    print('User from Basic Info : $user');
    return user == null
        ? Center(
            child: Loading(),
          )
        : Form(
            key: _formKey,
            child: SingleChildScrollView(
              controller: scrollController,
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 32),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 128,
                      width: 128,
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        image: DecorationImage(
                          image: NetworkImage(user.photoURL ??
                              'https://avatars1.githubusercontent.com/u/47744226?v=4, uid: udwUGw7jo6ha21cFwpkVqbgm4ZM2'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      alignment: Alignment.bottomRight,
                    ),
                  ),
                  SizedBox(height: 32),
                  TextFormField(
                    validator: (val) =>
                        val.isEmpty && alphaNumSpaceRegex.hasMatch(val)
                            ? 'Invalid firstname'
                            : null,
                    decoration:
                        textFieldDecoration.copyWith(labelText: 'First Name'),
                    onChanged: (val) => user.firstName = val,
                    initialValue: user.firstName ?? '',
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    validator: (val) =>
                        val.isEmpty || alphaNumSpaceRegex.hasMatch(val)
                            ? null
                            : 'Invalid lastname',
                    onChanged: (val) => user.lastName = val,
                    decoration:
                        textFieldDecoration.copyWith(labelText: 'Last Name'),
                    initialValue: user.lastName ?? '',
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    readOnly: true,
                    onChanged: (val) => user.email = val,
                    decoration:
                        textFieldDecoration.copyWith(labelText: 'Email'),
                    initialValue: user.email ?? '',
                  ),
                  SizedBox(height: 16),
                  StreamBuilder<bool>(
                    initialData: false,
                    stream: UserDatabase().checkAvailabilty(user.id),
                    builder: (_, ss) => TextFormField(
                      autovalidate: startAutoValidate && autoValidate,
                      validator: (val) => val.isEmpty || val.contains(' ')
                          ? 'Invalid ID'
                          : (ss.data && startAutoValidate
                              ? null
                              : 'Not Available'),
                      onChanged: (val) {
                        setState(() {
                          startAutoValidate = autoValidate = true;
                          user.id = val;
                        });
                      },
                      decoration: textFieldDecoration.copyWith(labelText: 'ID'),
                      initialValue: user.id ?? '',
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 128,
                      child: PrimaryButton(
                        function: () async {
                          setState(() {
                            autoValidate = false;
                          });
                          if (_formKey.currentState.validate()) {
                            await UserDatabase(uid: user.uid)
                                .updateUser(user.toBasicInfoJson());
                            pageController.nextPage(
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeIn,
                            );
                          } else {
                            setState(() {
                              autoValidate = true;
                            });
                          }
                        },
                        text: 'Next',
                        isExtended: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          );
  }
}
