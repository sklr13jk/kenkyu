import 'package:cloud_firestore/cloud_firestore.dart';

class ReadAmount {
  String documentID;
  String eventTime;
  String userEmail;
  String charactersRead;

  ReadAmount(DocumentSnapshot doc) {
    documentID = doc.id;
    eventTime = doc.data()['eventTime'];
    userEmail = doc.data()['createUser'];
    charactersRead = doc.data()['readAmount'];
  }
}
//firebaseからとってくるデータの形をこのアプリ好みに変えるための箱
