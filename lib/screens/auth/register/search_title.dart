import 'package:flutter/material.dart';
import 'package:joinup/models/title_model.dart';
import 'package:joinup/services/database/title_database.dart';
import 'package:joinup/shared/constants.dart';

class ChooseTitle extends StatefulWidget {
  @override
  _ChooseTitleState createState() => _ChooseTitleState();
}

class _ChooseTitleState extends State<ChooseTitle> {
  String title = '';
  List<TitleModel> titles = [];
  TextEditingController _textEditingController = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 16),
                TextFormField(
                  autovalidate: _autoValidate,
                  validator: (val) => val.replaceAll(' ', '').isEmpty
                      ? 'Title cannot be empty'
                      : null,
                  controller: _textEditingController,
                  decoration: textFieldDecoration.copyWith(labelText: 'Title'),
                  onChanged: (val) async {
                    setState(() {
                      title = val;
                    });
                    List<TitleModel> _titles =
                        await TitleDatabase(title.toLowerCase()).searchTitle();
                    // print('##### Titles');
                    // print(_titles);
                    // print('##### Titleeeeeee');
                    // print(title);
                    setState(() {
                      titles = _titles;
                    });
                  },
                ),
                buildSearcheResult(),
                ListTile(
                  onTap: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        _autoValidate = true;
                      });
                      await TitleDatabase(title).addTitle();
                      titles = await TitleDatabase(title.toLowerCase())
                          .searchTitle();
                      setState(() {
                        titles = titles;
                      });
                    }
                  },
                  title: Text(
                    "Create title '$title'",
                    textAlign: TextAlign.center,
                  ),
                ),
                // StreamBuilder<List<TitleModel>>(
                //     stream: TitleDatabase(title).searchTitle(),
                //     builder: (context, snapshot) {
                //       if (snapshot.hasData && snapshot.data.isNotEmpty) {
                //         print('Has Dataaaaaaa');
                //         return Column(
                //           children: snapshot.data
                //               .map((title) => Text(title.title))
                //               .toList(),
                //         );
                //       } else {
                //         if (title.isNotEmpty)
                //           return FlatButton(
                //             onPressed: () {
                //               TitleDatabase(title).addTitle();
                //             },
                //             child: Text("Create title '$title'"),
                //           );
                //         else
                //           return Container();
                //       }
                //     }),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Choose your title'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.check),
          )
        ],
      ),
    );
  }

  buildSearcheResult() {
    return Column(
      children: titles
          .map(
            (_title) => ListTile(
              onTap: () {
                setState(() {
                  _textEditingController.text = _title.title;
                });
              },
              title: Text(_title.title),
              trailing: Text(_title.numOfUses.toString()),
            ),
          )
          .toList(),
    );
  }
}
