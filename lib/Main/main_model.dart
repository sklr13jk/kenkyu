import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kenkyu_app/Amount/read_amount.dart';

class MainModel extends ChangeNotifier {
  String appBarTitle = '習慣実行画面';
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  List<ReadAmount> wordlist = [];
  List<String> dateTimeList;
  List<String> userEmailList;
  List<String> charactersReadList;
  String userEmail;
  List<String> currentUserReadList;
  List<String> currentUserTimeList;
  List<double> originalData;
  List<double> graphData = [];

  Future<void> handleSignOut() async {
    await FirebaseAuth.instance.signOut();
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print(e);
    }
    print(charactersReadList);
  }

  Future fetchEvents() async {
    final docs = await FirebaseFirestore.instance.collection('wordlist').get();
    final wordlist = docs.docs.map((doc) => ReadAmount(doc)).toList();
    this.wordlist = wordlist;
    dateTimeList = wordlist.map((event) => event.eventTime).toList();
    userEmailList = wordlist.map((event) => event.userEmail).toList();
    userEmailList = wordlist
        .map((event) => event.charactersRead)
        .toList(); //charactersReadなどはread_amountのページで定義したもの

    for (int i = 0; i < dateTimeList.length; i++) {
      if (userEmailList[i] == userEmail) {
        currentUserReadList[i] = charactersReadList[i];
        currentUserTimeList[i] = dateTimeList[i];
        //↑ここのループでバクってる説
      }
    }
    //print(charactersReadList);

    originalData = currentUserReadList.map(double.parse).toList();
    graphData = originalData.map((original) => original/1000).toList();
    //ここでエラーが起きている


    //print(graphData);
    notifyListeners();
  }
}
