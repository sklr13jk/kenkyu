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

  MainPage({User userData}) {
    this.userData = userData;
    this.name = userData.displayName;
    this.email = userData.email;
    this.photoUrl = userData.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    List<double> graphData = [0.1,0.3];
    List<Feature> features = [
      Feature(
        title: "自分が読んだ文字数",
        color: Colors.blue,
        data: graphData,
      ),
      // Feature(
      //   title: "Exercise",
      //   color: Colors.pink,
      //   data: [1, 0.8, 0.6, 0.7, 0.3],
      // ),
    ];
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      title: 'メイン画面',
      home: ChangeNotifierProvider<MainModel>(
        //todo ↑provederの中のconsumerの中だけがデータをうまく更新できたり、入れたり出したりできる。それ以外の場所はstatelesssidegetのような動きのないものになってしまう。
        create: (_) => MainModel()..fetchEvents(),
        child: Scaffold(
          //todo ↑scaffoldのなかに部品を書いていく。ボタンやアップバーなど。mainのbodyなど、順番はなんでもいい
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.book),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddWordPage(userEmail: email)),
                //↑AddWordPageっていうクラスないのuserEmailっていう変数にemailを代入しまっせ
              );
              //
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          //todo ↑場所の指定
          appBar: AppBar(
            // leading: Icon(Icons.menu),
            title: Consumer<MainModel>(builder: (context, model, child) {
              model.userEmail = email;
              graphData = model.graphData;
              //print(graphData);
              //todo ↑モデルのuseremailをemailに代入するよ
              return Text(model.appBarTitle);
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
          body: Consumer<MainModel>(builder: (context, model, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 64.0),
                  child: Text(
                    "Tasks Track",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                LineGraph(
                  features: features,
                  size: Size(500, 400),
                  labelX: [
                    'Day1',
                    'Day2',
                    'Day3',
                    'Day4',
                    'Day5',
                    'Day6',
                    'Day7',
                  ],
                  labelY: ['200文字', '400文字', '600文字', '800文字', '1000文字'],
                  showDescription: true,
                  graphColor: Colors.white30,
                ),
                SizedBox(
                  height: 50,
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
