import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final PageController controller;
  final int page;

  DrawerTile(this.icon, this.text, this.controller, this.page);
  
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (page == 3) {//Abre a caixa para sair ou nao da app
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
          } else {
            Navigator.of(context).pop();
            controller.jumpToPage(page);
          }
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 32.0,
                color: controller.page.round() == page
                    ? Theme.of(context).primaryColor
                    : Colors.grey[700],
              ),
              SizedBox(
                width: 32.0,
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
