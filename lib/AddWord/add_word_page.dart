import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kenkyu_app/Main/main_model.dart';
import 'package:provider/provider.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

// ignore: must_be_immutable
class AddWordPage extends StatelessWidget {
  final textController = TextEditingController();
  final String userEmail;

  AddWordPage({this.userEmail});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<MainModel>(
      create: (_) => MainModel()..fetchEvents(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('読んだ文字数を追加しよう！'),
        ),
        body: Consumer<MainModel>(
          builder: (context, model, child) {
            model.userEmail = userEmail;
            model.days = null;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: <Widget>[
                TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  controller: textController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "数値を入力してください。",
                    hintText: '例: 500',
                    icon: Icon(Icons.person_outline),
                    fillColor: Colors.white,
                  ),
                  onChanged: (text) {
                    model.words = text;
                  },
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      child: Text('１日目に記録する'),
                      onPressed: () async {
                        if (model.words == null || model.words == "") {
                          await nullEvent(context); //todo 文字数を入力してない場合に表示する
                        } else if (model.daysFinder[1] == true) {
                          model.days = await Future.value(1);
                          await changeWord(model, context);
                          await model.fetchEvents();
                          Navigator.pop(context, true);
                        } else {
                          model.days = await Future.value(1);
                          await addWord(model, context);
                          // todo:cloudFireStoreに文字数を追加
                          await model.fetchEvents();
                          Navigator.pop(context, true);
                        }
                      },
                    ),
                    SizedBox(width: 16.0),
                    RaisedButton(
                      child: Text('２日目に記録する'),
                      onPressed: () async {
                        if (model.words == null || model.words == "") {
                          await nullEvent(context); //todo 文字数を入力してない場合に表示する
                        } else if (model.daysFinder[2] == true) {
                          model.days = await Future.value(2);
                          await changeWord(model, context);
                          await model.fetchEvents();
                          Navigator.pop(context, true);
                        } else {
                          model.days = await Future.value(2);
                          await addWord(model, context);
                          // todo:cloudFireStoreに文字数を追加
                          await model.fetchEvents();
                          Navigator.pop(context, true);
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      child: Text('３日目に記録する'),
                      onPressed: () async {
                        if (model.words == null || model.words == "") {
                          await nullEvent(context); //todo 文字数を入力してない場合に表示する
                        } else if (model.daysFinder[3] == true) {
                          model.days = await Future.value(3);
                          await changeWord(model, context);
                          await model.fetchEvents();
                          Navigator.pop(context, true);
                        } else {
                          model.days = await Future.value(3);
                          await addWord(model, context);
                          // todo:cloudFireStoreに文字数を追加
                          await model.fetchEvents();
                          Navigator.pop(context, true);
                        }
                      },
                    ),
                    SizedBox(width: 16.0),
                    RaisedButton(
                      child: Text('４日目に記録する'),
                      onPressed: () async {
                        if (model.words == null || model.words == "") {
                          await nullEvent(context); //todo 文字数を入力してない場合に表示する
                        } else if (model.daysFinder[4] == true) {
                          model.days = await Future.value(4);
                          await changeWord(model, context);
                          await model.fetchEvents();
                          Navigator.pop(context, true);
                        } else {
                          model.days = await Future.value(4);
                          await addWord(model, context);
                          // todo:cloudFireStoreに文字数を追加
                          await model.fetchEvents();
                          Navigator.pop(context, true);
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      child: Text('５日目に記録する'),
                      onPressed: () async {
                        if (model.words == null || model.words == "") {
                          await nullEvent(context); //todo 文字数を入力してない場合に表示する
                        } else if (model.daysFinder[5] == true) {
                          model.days = await Future.value(5);
                          await changeWord(model, context);
                          await model.fetchEvents();
                          Navigator.pop(context, true);
                        } else {
                          model.days = await Future.value(5);
                          await addWord(model, context);
                          // todo:cloudFireStoreに文字数を追加
                          await model.fetchEvents();
                          Navigator.pop(context, true);
                        }
                      },
                    ),
                    SizedBox(width: 16.0),
                    RaisedButton(
                      child: Text('６日目に記録する'),
                      onPressed: () async {
                        if (model.words == null || model.words == "") {
                          await nullEvent(context); //todo 文字数を入力してない場合に表示する
                        } else if (model.daysFinder[6] == true) {
                          model.days = await Future.value(6);
                          await changeWord(model, context);
                          await model.fetchEvents();
                          Navigator.pop(context, true);
                        } else {
                          model.days = await Future.value(6);
                          await addWord(model, context);
                          // todo:cloudFireStoreに文字数を追加
                          await model.fetchEvents();
                          Navigator.pop(context, true);
                        }
                      },
                    ),
                  ],
                ),
                RaisedButton(
                  child: Text('７日目に記録する'),
                  onPressed: () async {
                    if (model.words == null || model.words == "") {
                      await nullEvent(context); //todo 文字数を入力してない場合に表示する
                    } else if (model.daysFinder[7] == true) {
                      model.days = await Future.value(7);
                      await changeWord(model, context);
                      await model.fetchEvents();
                      Navigator.pop(context, true);
                    } else {
                      model.days = await Future.value(7);
                      await addWord(model, context);
                      // todo:cloudFireStoreに文字数を追加
                      await model.fetchEvents();
                      Navigator.pop(context, true);
                    }
                  },
                ),
              ]),
            );
          },
        ),
      ),
    );
  }

  Future addWord(MainModel model, BuildContext context) async {
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

  Future changeWord(MainModel model, BuildContext context) async {
    await model.changeEvent();
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('文字数を訂正しました！'),
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

  //todo 文字数を入力しなかった時に出る警告
  Future nullEvent(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('文字数を入力してください。'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
