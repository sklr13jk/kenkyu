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
  List<int> currentUserDaysList;
  List<String> currentUserIdList;
  String words;
  int days;
  List<bool> daysFinder = [
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  Map<int, List> eventSubList = {};
  Map<int, List> eventList = {};

  Future<void> handleSignOut() async {
    await FirebaseAuth.instance.signOut();
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future fetchEvents() async {
    eventSubList = {};
    eventList = {};
    currentUserReadList = [0];
    currentUserDaysList = [0];
    currentUserIdList = ["dummy"];
    final docs = await FirebaseFirestore.instance.collection('wordList').get();
    final wordList = docs.docs.map((doc) => ReadAmount(doc)).toList();
    this.wordList = wordList;
    final userDaysList = wordList.map((event) => event.readDays).toList();
    final userEmailList = wordList.map((event) => event.userEmail).toList();
    final userReadList = wordList.map((event) => event.charactersRead).toList();
    final idList = wordList.map((event) => event.documentID).toList();
    print('userDaysList:${userDaysList.length}');
    print('userEmailList:${userEmailList.length}');
    print('userReadList:${userReadList.length}');
    print('idList:${idList.length}');
    //todo リスト数確認

    final originalData =
        userReadList.map(int.parse).toList(); //todo Stringリスト→intリスト
    final doubleOriginalData = originalData.map((i) => i.toDouble()).toList();
    final doubleUserReadList =
        doubleOriginalData.map((original) => original / 5000).toList();

    for (int i = 0; i < userEmailList.length; i++) {
      if (userEmailList[i] == userEmail) {
        currentUserReadList.add(doubleUserReadList[i]);
        currentUserDaysList.add(userDaysList[i]);
        currentUserIdList.add(idList[i]);
      }
    }
    print('currentUserReadList:${currentUserReadList.length}');
    print('currentUserDaysList:${currentUserDaysList.length}');
    print('currentUserIdList:${currentUserIdList.length}');

    for (int i = 0; i < currentUserDaysList.length; i++) {
      eventSubList[currentUserDaysList[i]] = [
        currentUserIdList[i],
        currentUserReadList[i]
      ];
    }

    for (int i = 0; i < 8; i++) {
      if (eventSubList.containsKey(i)) {
        eventList[i] = [eventSubList[i][0], eventSubList[i][1]];
        daysFinder[i] = true;
      } else {
        eventList[i] = ['dummy', 0.0];
        daysFinder[i] = false;
      }
    }

    print(eventList);
    print(daysFinder);

    notifyListeners();
  }

  Future addWordsToFirebase() async {
    await FirebaseFirestore.instance.collection('wordList').add({
      'readAmount': words,
      'eventTime': DateTime.now(),
      'createUser': userEmail,
      'readDays': days,
    });
  }

  Future changeEvent() async {
    String todayId = await eventList[days][0];
    DocumentReference todayEvent =
        FirebaseFirestore.instance.collection('wordList').doc(todayId);
    await todayEvent.update({
      'readAmount': words,
      'eventTime': DateTime.now(),
      'createUser': userEmail,
      'readDays': days,
    });
  }
}
