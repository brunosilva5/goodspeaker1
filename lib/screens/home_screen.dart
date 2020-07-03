import 'package:flutter/material.dart';
import 'package:pt/screens/home.dart';
import 'package:pt/screens/jogoAPI.dart';
import 'package:pt/screens/profile.dart';
import 'package:pt/widgtes/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text(""),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: Home(),
          backgroundColor: Colors.white,
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Good Speaker"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: PlayGameAPI(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Perfil"),
            centerTitle: true,
            backgroundColor: Colors.teal,
            iconTheme: IconThemeData(color: Colors.white),
            elevation: 0.0,
          ),
          drawer: CustomDrawer(_pageController),
          body: Profile(),
        ),
        Container(color: Colors.green,),
      ],
    );
  }
}