import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AddWordModel extends ChangeNotifier {
  String words;
  String userEmail;

  Future addWordsToFirebase() async {
    if (words.isEmpty) {
      throw('文字数を入力して下さい');
    }
    FirebaseFirestore.instance.collection('wordlist').add({
      'readAmount': words,
      'eventTime': DateTime.now().toString(),
      'createUser':userEmail,
      // 'createUser':,
    });
  }
}
