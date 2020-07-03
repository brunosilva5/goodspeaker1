import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pt/models/user_model.dart';
import 'package:pt/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //Com esta linha abaixo, a aplicação apenas fica na vertical
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    //Esconder a statusbar, para tirar print xD
    SystemChrome.setEnabledSystemUIOverlays ([SystemUiOverlay.bottom]);
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: MaterialApp(
        title: "Good Speaker",
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color.fromARGB(255, 4, 125, 141),
        ),
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
