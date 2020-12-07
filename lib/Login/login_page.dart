import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kenkyu_app/Login/login_model.dart';
import 'package:kenkyu_app/Main/main_page.dart';
import 'package:provider/provider.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(LoginPage());
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      title: 'readingHabitFormationApp',
      home: ChangeNotifierProvider<LoginModel>(
        create: (_) => LoginModel(),
        //↑これ何？
        child: Scaffold(
          appBar: AppBar(
            title: Text('googleアカウントでログインしてください。'),
          ),
          body: Consumer<LoginModel>(builder: (context, model, child) {
            return Center(
              //↑ここのreturnの意味は？
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Sign in Google'),
                      onPressed: () async {
                        await model
                            .handleSignIn()
                            .then((User user) => {
                          if (user == null)
                          //↑ここのuserってどこで定義したん？
                            {}
                          else
                            {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MainPage(userData: user)))
                            },
                        })
                            .catchError((e) => print(e));
                      },
                    ),
                  ]),
            );
          }),
        ),
      ),
    );
  }
}
