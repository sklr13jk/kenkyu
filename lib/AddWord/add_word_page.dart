import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_word_model.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

// ignore: must_be_immutable
class AddWordPage extends StatelessWidget {
  final textController = TextEditingController();
  final String userEmail;

  AddWordPage({this.userEmail});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<AddWordModel>(
      create: (_) => AddWordModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('読んだ文字数を追加してください'),
        ),
        body: Consumer<AddWordModel>(
          builder: (context, model, child) {
            model.userEmail = userEmail;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: <Widget>[
                TextField(
                  controller: textController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "数値を入力してください。",
                    hintText: '例（114514）',
                    icon: Icon(Icons.person_outline),
                    fillColor: Colors.white,
                  ),
                  onChanged: (text) {
                    model.words = text;
                  },
                ),
                Consumer<AddWordModel>(builder: (context, model, child) {
                  return RaisedButton(
                    child: Text('追加する'),
                    onPressed: () async {
                      await addWord(model, context);
                      // todo:firesotreに文字数を追加
                      Navigator.of(context).pop();
                    },

                  );
                }),
              ]),
            );
          },
        ),
      ),
    );
  }

  Future addWord(AddWordModel model, BuildContext context) async {
    await model.addWordsToFirebase();
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('入力を完了しました！'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
