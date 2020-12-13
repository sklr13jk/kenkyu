import 'package:cloud_firestore/cloud_firestore.dart';

class ReadAmount {
  String documentID;
  int readDays;
  String userEmail;
  String charactersRead;

  ReadAmount(DocumentSnapshot doc) {
    documentID = doc.id;
    readDays = doc.data()['readDays'];
    userEmail = doc.data()['createUser'];
    charactersRead = doc.data()['readAmount'];
  }
}
//firebaseからとってくるデータの形をこのアプリ好みに変えるための箱
