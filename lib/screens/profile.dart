import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pt/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

import 'editFonema.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    getFonemasData();
  }

  //CurrentUser//verificar user para obter os fonemas
  FirebaseUser user;
  var word;
  var fonemasUser = new List();
  List fonemasLista;
  Future<void> getFonemasData() async {
    FirebaseUser userData = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot snapshot = await Firestore.instance
        .collection('fonemas')
        .document(userData.uid)
        .get();
    setState(() {
      user = userData;
      fonemasUser.addAll(snapshot.data.values);
      print(fonemasUser[0]);
      fonemasUser = fonemasUser[0];

      fonemasLista = new List();
      for (var i = 0; i <= fonemasUser.length - 1; i++) {
        if (fonemasUser[i] == 1) fonemasLista.add("/p/");
        if (fonemasUser[i] == 2) fonemasLista.add("/b/");
        if (fonemasUser[i] == 3) fonemasLista.add("/t/");
        if (fonemasUser[i] == 4) fonemasLista.add("/d/");
        if (fonemasUser[i] == 5) fonemasLista.add("/k/");
        if (fonemasUser[i] == 6) fonemasLista.add("/g/");
        if (fonemasUser[i] == 7) fonemasLista.add("/t/");
        if (fonemasUser[i] == 8) fonemasLista.add("/v/");
        if (fonemasUser[i] == 9) fonemasLista.add("/s/");
        if (fonemasUser[i] == 10) fonemasLista.add("/z/");
        if (fonemasUser[i] == 11) fonemasLista.add("/S/");
        if (fonemasUser[i] == 12) fonemasLista.add("/Ʒ/");
        if (fonemasUser[i] == 13) fonemasLista.add("/m/");
        if (fonemasUser[i] == 14) fonemasLista.add("/n/");
        if (fonemasUser[i] == 15) fonemasLista.add("/ɲ/");
        if (fonemasUser[i] == 16) fonemasLista.add("/l/");
        if (fonemasUser[i] == 17) fonemasLista.add("/r/");
        if (fonemasUser[i] == 18) fonemasLista.add("/3/");
        if (fonemasUser[i] == 19) fonemasLista.add("/R/");
        if (fonemasUser[i] == 20) fonemasLista.add("/N/");
      }
      print(fonemasLista);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(child:
        ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      return model.isLoggedIn()
          ? Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.teal, Colors.tealAccent],
                      ),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0))),
                  child: Container(
                    width: double.infinity,
                    height: 350.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: NetworkImage(model.user.photoUrl),
                          radius: 70.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(
                            model.user.displayName,
                            //"Joaquim António",
                            style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: OutlineButton(
                            color: Colors.transparent,
                            textColor: Colors.white,
                            padding: EdgeInsets.all(10.0),
                            splashColor: Colors.teal,
                            highlightedBorderColor: Colors.transparent,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditarFonema()));
                            },
                            child: Text(
                              "Editar Fonemas",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(25.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Email",
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  model.user.email,
                                  //"goodspeaker@gmail.com",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Fonemas",
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  Text(
                                    fonemasLista.toString(),
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Align(
              alignment: Alignment.center,
              child: Text(
                "Precisa de efetuar login para acessar a esta página",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
            );
    }));
  }
}
