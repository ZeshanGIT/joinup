import 'package:flutter/material.dart';
import 'package:joinup/services/database/test.dart';

class Home extends StatelessWidget {
  final String uid;
  Home(this.uid);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () async {
            RevathiStores().getData();
          },
          child: Text('Press'),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return StreamBuilder<User>(
  //     stream: UserDatabase(uid: uid).getUserFromFirebaseUser(),
  //     builder: (_, ss) {
  //       if (ss.hasData)
  //         return Scaffold(
  //           body: Container(
  //             alignment: Alignment.center,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 RaisedButton(
  //                   onPressed: () {
  //                     AuthService().signOut();
  //                   },
  //                   child: Text(ss.data.firstName ?? 'Null'),
  //                 ),
  //                 FlatButton(
  //                   onPressed: () {
  //                     AuthService().deleteAccount(uid);
  //                   },
  //                   child: Text(ss.data.firstName ?? 'Null'),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       else {
  //         return Scaffold(
  //           body: Center(
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 Text('Something went wrong !'),
  //                 FlatButton(
  //                   onPressed: () {
  //                     AuthService().signOut();
  //                   },
  //                   child: Text('Try Again'),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }
}
