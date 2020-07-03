import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pt/datas/data.dart';
import 'package:pt/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class FonemasModel extends Model{

  UserModel user;

  List<FonemasModel> fonemas = [];

  FonemasModel(this.user);

  
}