import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditarFonema extends StatefulWidget {
  @override
  _EditarFonemaState createState() => _EditarFonemaState();
}

class _EditarFonemaState extends State<EditarFonema> {
  Map<String, bool> values = {
    '/p/': false,
    '/b/': false,
    '/t/': false,
    '/d/': false,
    '/k/': false,
    '/g/': false,
    '/t/': false,
    '/v/': false,
    '/s/': false,
    '/z/': false,
    '/S/': false,
    '/Ʒ/': false,
    '/m/': false,
    '/n/': false,
    '/ɲ/': false,
    '/l/': false,
    '/l/': false,
    '/r/': false,
    '/3/': false,
    '/R/': false,
    '/N/': false,
  };
  List<String> novosFonemas = new List();
  FirebaseUser user;
  List newFonemas;

  Future<void> getUserData() async {
    FirebaseUser userData = await FirebaseAuth.instance.currentUser();
    setState(() {
      user = userData;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Editar"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Deseja guardar as alterações?"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Cancelar"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                          child: Text("Sim"),
                          onPressed: () {
                            getNewFonemas();
                            Firestore.instance
                                .collection("fonemas")
                                .document(user.uid)
                                .setData({'fonemas': newFonemas});
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  });
            },
          ),
        ],
      ),
      body: new ListView(
        children: values.keys.map(
          (String key) {
            return new CheckboxListTile(
                title: new Text(key),
                value: values[key],
                onChanged: (bool value) {
                  setState(() {
                    values[key] = value;
                    if (value) {
                      novosFonemas.add(key);
                    } else {
                      novosFonemas.remove(key);
                    }
                    print(novosFonemas);
                  });
                });
          },
        ).toList(),
      ),
    );
  }

  Future<void> getNewFonemas() async {
    newFonemas = new List();
    for (var i = 0; i <= novosFonemas.length - 1; i++) {
      if (novosFonemas[i] == "/p/") newFonemas.add(1);
      if (novosFonemas[i] == "/b/") newFonemas.add(2);
      if (novosFonemas[i] == "/t/") newFonemas.add(3);
      if (novosFonemas[i] == "/d/") newFonemas.add(4);
      if (novosFonemas[i] == "/k/") newFonemas.add(5);
      if (novosFonemas[i] == "/g/") newFonemas.add(6);
      if (novosFonemas[i] == "/t/") newFonemas.add(7);
      if (novosFonemas[i] == "/t/") newFonemas.add(8);
      if (novosFonemas[i] == "/t/") newFonemas.add(9);
      if (novosFonemas[i] == "/t/") newFonemas.add(10);
      if (novosFonemas[i] == "/S/") newFonemas.add(11);
      if (novosFonemas[i] == "/Ʒ/") newFonemas.add(12);
      if (novosFonemas[i] == "/m/") newFonemas.add(13);
      if (novosFonemas[i] == "/n/") newFonemas.add(14);
      if (novosFonemas[i] == "/ɲ/") newFonemas.add(15);
      if (novosFonemas[i] == "/l/") newFonemas.add(16);
      if (novosFonemas[i] == "/r/") newFonemas.add(17);
      if (novosFonemas[i] == "/3/") newFonemas.add(18);
      if (novosFonemas[i] == "/R/") newFonemas.add(19);
      if (novosFonemas[i] == "/N/") newFonemas.add(20);
    }
  }
}
