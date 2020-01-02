import 'package:flutter/material.dart';

const InputDecoration textFieldDecoration = InputDecoration(
  border: OutlineInputBorder(),
);

const String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
    "\\@" +
    "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
    "(" +
    "\\." +
    "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
    ")+";
RegExp emailRegex = RegExp(p);

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function function;

  PrimaryButton({
    @required this.text,
    @required this.function,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
