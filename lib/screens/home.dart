import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pt/models/user_model.dart';
import 'package:pt/screens/home_screen.dart';
import 'package:pt/screens/jogoAPI.dart';
import 'package:pt/widgtes/custom_drawer.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:pt/tiles/drawer_tile.dart';

class Home extends StatelessWidget {
  PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          return Stack(
            children: <Widget>[
              Align(
                alignment: Alignment(0.0, -0.6),
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    width: 180.0,
                    height: 180.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              !model.isLoggedIn() ? Align(
                alignment: Alignment(0.0, -0.0),
                child: OutlineButton(
                  child: Text(
                    "Entrar",
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  borderSide: BorderSide(
                    color: Colors.teal,
                  ),
                  highlightedBorderColor: Colors.teal,
                  splashColor: Colors.teal,
                  onPressed: () {
                      model.signIn();
                  },
                ),
              ): 
              Container(),
              model.isLoggedIn()
                  ? Align(
                      alignment: Alignment(0.0, 0.2),
                      child: OutlineButton(
                        child: Text(
                          "Sair",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.red,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.teal,
                        ),
                        highlightedBorderColor: Colors.teal,
                        splashColor: Colors.teal,
                        onPressed: () {
                          return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Confirme"),
                                content: Text("Pretende sair da aplicação?"),
                                actions: <Widget>[
                                  RaisedButton(
                                    child: Text("Não"),
                                    color: Colors.white,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RaisedButton(
                                    child: Text("Sim"),
                                    color: Colors.white,
                                    onPressed: () {
                                      SystemChannels.platform
                                          .invokeMethod('SystemNavigator.pop');
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    )
                  : Container(),
            ],
          );
        },
      ),
    );
  }
}
