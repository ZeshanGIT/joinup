import 'package:flutter/material.dart';

const InputDecoration textFieldDecoration = InputDecoration(
  border: OutlineInputBorder(),
);

const whiteText = TextStyle(color: Colors.white);

const String _email = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
    "\\@" +
    "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
    "(" +
    "\\." +
    "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
    ")+";
RegExp emailRegex = RegExp(_email);

const String _alphaNumSpace = '[a-zA-Z0-9 ]*';
RegExp alphaNumSpaceRegex = RegExp(_alphaNumSpace);

const String _id = '^(?!.*\.\.)(?!.*\.\$)[^\W][\w.]{0,29}\$';
RegExp idRegex = RegExp(_id);

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function function;
  final bool isExtended;

  PrimaryButton({
    @required this.text,
    @required this.function,
    Key key,
    this.isExtended = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isExtended ? double.maxFinite : null,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 8.0,
            offset: Offset(0, 4),
            color: Colors.pink[300].withAlpha(50),
          )
        ],
      ),
      child: RaisedButton(
        shape: StadiumBorder(),
        color: Theme.of(context).primaryColor,
        onPressed: function,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            text,
            style: Theme.of(context).primaryTextTheme.button,
          ),
        ),
      ),
    );
  }
}
