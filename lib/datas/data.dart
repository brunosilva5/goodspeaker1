import 'package:cloud_firestore/cloud_firestore.dart';

class FonemasData {

  String cid;
  List<int> fonemas;

  FonemasData.fromDocument(DocumentSnapshot snapshot){
    cid = snapshot.documentID;
    fonemas = snapshot.data["fonemas"];
  }

  Map<String, dynamic> toMap(){
    return{
      "fonemas": fonemas
    };
  }

}