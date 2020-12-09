import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kenkyu_app/Amount/read_amount.dart';

class MainModel extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  List<ReadAmount> wordList;
  String userEmail;
  List<double> currentUserReadList = [0];
  List<String> currentUserTimeList = ['start'];
  List<String> currentUserIdList = [];
  Map<String, List> eventList;
  String words;
  List<double> dummyReadList = [0];

  Future<void> handleSignOut() async {
    await FirebaseAuth.instance.signOut();
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future fetchEvents() async {
    currentUserReadList = [0];
    currentUserTimeList = ['start'];
    currentUserIdList = [userEmail];
    eventList = {};
    final docs = await FirebaseFirestore.instance.collection('wordList').get();
    final wordList = docs.docs.map((doc) => ReadAmount(doc)).toList();
    this.wordList = wordList;
    final dateTimeList = wordList.map((event) => event.eventTime).toList();
    final userEmailList = wordList.map((event) => event.userEmail).toList();
    final charactersReadList =
        wordList.map((event) => event.charactersRead).toList();
    final idList = wordList.map((event) => event.documentID).toList();
    print('dateTimeList:${dateTimeList.length}');
    print('userEmailList:${userEmailList.length}');
    print('charactersReadList:${charactersReadList.length}');
    print('idList:${idList.length}');
    //todo リスト数確認

    final originalData =
        charactersReadList.map(int.parse).toList(); //todo Stringリスト→intリスト
    final doubleOriginalData = originalData.map((i) => i.toDouble()).toList();
    final allUserReadList =
        doubleOriginalData.map((original) => original / 1000).toList();

    for (int i = 0; i < userEmailList.length; i++) {
      if (userEmailList[i] == userEmail) {
        currentUserReadList.add(allUserReadList[i]);
        currentUserTimeList.add(dateTimeList[i]);
        currentUserIdList.add(idList[i]);
        eventList[currentUserTimeList[i]] = [
          currentUserReadList[i],
          currentUserIdList[i]
        ];
      }
    }
    print('currentUserReadList:${currentUserReadList.length}');
    print('currentUserTimeList:${currentUserTimeList.length}');
    // print('currentUserIdList:${currentUserIdList.length}');
    print(eventList);
    //todo リスト数確認

    notifyListeners();
  }

  Future addWordsToFirebase() async {
    DateTime time = DateTime.now();
    DateTime yearToDay = DateTime(time.year, time.month, time.day);
    await FirebaseFirestore.instance.collection('wordList').add({
      'readAmount': words,
      'eventTime': yearToDay.toString(),
      'createUser': userEmail,
    });
  }

  Future changeEvent() async {
    DateTime time = DateTime.now();
    DateTime yearToDay = DateTime(time.year, time.month, time.day);
    String todayId = eventList[yearToDay][1];
    final todayEvent =
        FirebaseFirestore.instance.collection('events').doc(todayId);
    await todayEvent.update(
      {
        'readAmount': '0',
        'eventTime': yearToDay.toString(),
        'createUser': userEmail,
      },
    );
  }
}
