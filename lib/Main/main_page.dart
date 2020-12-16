import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kenkyu_app/AddWord/add_word_page.dart';
import 'package:kenkyu_app/Login/login_page.dart';
import 'package:kenkyu_app/Main/main_model.dart';
import 'package:provider/provider.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

// ignore: must_be_immutable
class MainPage extends StatelessWidget {
  User userData;
  String name = '';
  String email;
  String photoUrl;
  List<double> graphData = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];
  Map<String, double> eventList;

  MainPage({User userData}) {
    this.userData = userData;
    this.name = userData.displayName;
    this.email = userData.email;
    this.photoUrl = userData.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      title: 'メイン画面',
      home: ChangeNotifierProvider<MainModel>(
        //todo ↑provederの中のconsumerの中だけがデータをうまく更新できたり、入れたり出したりできる。それ以外の場所はstatelesssidegetのような動きのないものになってしまう。
        create: (_) => MainModel()..fetchEvents(),
        child: Scaffold(
          //todo ↑scaffoldのなかに部品を書いていく。ボタンやアップバーなど。mainのbodyなど、順番はなんでもいい
          floatingActionButton:
              Consumer<MainModel>(builder: (context, model, child) {
            return FloatingActionButton(
              child: Icon(Icons.arrow_right),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddWordPage(
                      userEmail: email,
                    ),
                    fullscreenDialog: true, //todo ページ遷移の仕方変わってます
                  ),
                  //↑AddWordPageっていうクラスないのuserEmailっていう変数にemailを代入しまっせ
                );
                model.fetchEvents();
              },
            );
          }),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          //todo ↑場所の指定
          appBar: AppBar(
            title: Consumer<MainModel>(builder: (context, model, child) {
              model.userEmail = email;
              //todo ↑モデルのuseremailをemailに代入するよ
              return Text('グラフ画面');
              //todo ↑{}があると大体returnする
            }),
          ),
          drawer: Consumer<MainModel>(
            builder: (context, model, child) {
              return Drawer(
                //todo ↑アカウントのパーツ
                child: Column(children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(name),
                    accountEmail: Text(email),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(photoUrl),
                    ),
                  ),
                  RaisedButton(
                    child: Text('Sign Out Google'),
                    onPressed: () {
                      model.handleSignOut().catchError((e) => print(e));
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginPage();
                          },
                        ),
                      );
                    },
                  ),
                ]),
              );
            },
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 64.0),
                child: Text(
                  "読書量を確認しよう！",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              Consumer<MainModel>(builder: (context, model, child) {
                graphData = [
                  model.eventList[0][1],
                  model.eventList[1][1],
                  model.eventList[2][1],
                  model.eventList[3][1],
                  model.eventList[4][1],
                  model.eventList[5][1],
                  model.eventList[6][1],
                  model.eventList[7][1],
                ];
                List<Feature> features = [
                  Feature(
                    title: "自分が読んだ文字数",
                    color: Colors.blue,
                    data: graphData,
                  ),
                ];
                return LineGraph(
                  features: features,
                  size: Size(500, 400),
                  labelX: [
                    '  ',
                    'Day1',
                    'Day2',
                    'Day3',
                    'Day4',
                    'Day5',
                    'Day6',
                    'Day7',
                  ],
                  labelY: [
                    '1000文字',
                    '2000文字',
                    '3000文字',
                    '4000文字',
                    '5000文字',
                    '6000文字'
                  ],
                  showDescription: true,
                  graphColor: Colors.white30,
                );
              }),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
