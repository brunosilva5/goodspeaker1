import 'dart:async';
import 'dart:io'; //para aguardar uns segundos
import 'dart:math'; //random number
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Biblioteca TTS
import 'package:pt/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:speech_to_text/speech_recognition_error.dart'; // Biblioteca STT
import 'package:speech_to_text/speech_recognition_result.dart'; // Biblioteca STT
import 'package:speech_to_text/speech_to_text.dart'; // Biblioteca STT
import 'package:fluttertoast/fluttertoast.dart'; //Informar as tentativas!
import 'package:http/http.dart' as http; //Para a API
import 'dart:convert'; //Para ler json da API

class PlayGameAPI extends StatefulWidget {
  @override
  _PlayGameAPIState createState() => _PlayGameAPIState();
}

enum TtsState { playing, stopped }

class _PlayGameAPIState extends State<PlayGameAPI> {
  //Variáveis para o STT
  String palavraDita;
  bool _hasSpeech = false;
  bool _stressTest = false;
  double level = 0.0;
  int _stressLoops = 0;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "pt-PT";
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();

  //Variáveis para o TTS
  FlutterTts flutterTts;
  dynamic languages;
  String language = "pt-PT";
  double volume = 1.0;
  double pitch = 0.9;
  double rate = 0.9;
  bool obterWord = true;
  String _newVoiceText = "pão";

  TtsState ttsState = TtsState.stopped;

  //Fonema do utilizador
  var fonemasUser = new List(); //lista de fonemas do utilizador atual

  //CurrentUser//verificar user para obter os fonemas
  FirebaseUser user;

  Future<void> getUserData() async {
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
    });
  }

  //Tentativas
  int tentativas = 3; // GUARDA O NÚMERO DE TENTATIVAS RESTANTES

  int fonemaRandom;

  Future<Map> _getWord() async {
    print("entrei aqui");
    //generate a random word
    Random rndfonema = new Random();
    var _word = fonemasUser[rndfonema.nextInt(fonemasUser.length)];
    print(_word);
    http.Response response;
    if (_word == null) {
      print("word aleatoria");
      Random rndWord = new Random();
      fonemaRandom = (rndWord.nextInt(19)) + 1;
      response = await http.get(
          "https://word-generator-api.herokuapp.com/api/word/$fonemaRandom");
    } else {
      print("word NAO aleatoria");
      response = await http
          .get("https://word-generator-api.herokuapp.com/api/word/$_word");
    }

    return json.decode(response.body);
  }

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  @override
  void initState() {
    super.initState();
    getUserData();
    //Iniciar a requisicao da palavra atraves da api
    //_getWord().then((map) => print(map)); //testar a API
    initTts();
    initSpeechState(); //Coloquei aqui o initSpeechState, para que a aplicação esteja pronta
    //para ser usada quando o botao do microfone for pressionado,
    //sem que seja necessário pressionar o botão para iniciar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          obterWord
              ? FutureBuilder(
                  future: _getWord(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Container(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.teal),
                            strokeWidth: 5.0,
                          ),
                        );
                      default:
                        if (snapshot.hasError) {
                          print("deu merda pah");
                          //return Container();
                          return Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Precisa de efetuar login para acessar a esta página! Caso se encontre autenticado, adicione os fonemas que tem dificuldade no seu perfil",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w300,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        } else {
                          obterWord = false;
                          print("siga");
                          _newVoiceText = snapshot.data["word"];
                          return _play(context);
                        }
                    }
                  },
                )
              : _play(context)
        ],
      ),
    );
  }

  Widget _play(BuildContext context) {
    return Container(child:
        ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      return model.isLoggedIn()
          ? Scaffold(
              backgroundColor: Colors.white,
              body: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment(0.0, -0.55),
                    child: Container(
                      child: Text(
                        _newVoiceText,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 35.0),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0.0, -0.4),
                    child: IconButton(
                      tooltip: 'Ouvir',
                      icon: Icon(
                        Icons.play_circle_outline,
                        color: Colors.green,
                        size: 50.0,
                      ),
                      onPressed: _speak,
                      padding: const EdgeInsets.all(
                          0), //centrar o icon com centro do seu espaço
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      lastWords,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25.0,
                          color: lastWords == _newVoiceText
                              ? Colors.green
                              : Colors.red),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0.0, 0.7),
                    child: IconButton(
                      tooltip: 'Clique para falar',
                      icon: Icon(
                        Icons.mic,
                        color: Colors.teal,
                        size: 50.0,
                      ),
                      onPressed: startListening,
                      padding: const EdgeInsets.all(0),
                    ),
                  ),
                ],
              ),
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

  //Função auxiliar
  void generateWord() {
    /* Random random = new Random();
    _newVoiceText = palavras[random.nextInt(7)]; */
    obterWord = true;
  }

  //Funções para o Speech to text  --  Se possível, colocar estas funções num helper /helpers/STT

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  void changeStatusForStress(String status) {
    if (!_stressTest) {
      return;
    }
    if (speech.isListening) {
      stopListening();
    } else {
      if (_stressLoops >= 100) {
        _stressTest = false;
        print("Stress test complete.");
        return;
      }
      print("Stress loop: $_stressLoops");
      ++_stressLoops;
      startListening();
    }
  }

  void startListening() {
    lastWords = "";
    lastError = "";
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 10),
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        partialResults: true);
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords}";
    });

    if (lastWords != "") {
      if (lastWords == _newVoiceText) {
        Future.delayed(const Duration(milliseconds: 500), () {
          // Here you can write your code
          generateWord();
          setState(() {
            // Here you can write your code for open new view
            lastWords = "";
            tentativas = 3;
          });
        });
      } else {
        setState(() {
          tentativas -= 1;
          snackBarTentativas(); // Mostra uma snackbar com as tentativas atuais
        });
        if (tentativas == 0) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            //Se acabarem as tentativas, a palavra muda e o numero de tentativas é reposto
            generateWord();
            setState(() {
              lastWords = "";
              tentativas = 3;
            });
          });
        }
      }
    }
  }

  void soundLevelListener(double level) {
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    changeStatusForStress(status);
    setState(() {
      lastStatus = "$status";
    });
  }

  //Funções para o Text To Speech  --  Se possível, colocar estas funções num helper /helpers/TTS

  initTts() {
    flutterTts = FlutterTts();

    flutterTts.setStartHandler(() {
      setState(() {
        print("playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_newVoiceText == null) {
      //adicioando
      generateWord();
    }
    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        var result = await flutterTts.speak(_newVoiceText);
        if (result == 1) setState(() => ttsState = TtsState.playing);
      }
    }
  }

  /* Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  } */

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  void _onChange(String text) {
    setState(() {
      _newVoiceText = text;
    });
  }

  Widget snackBarTentativas() {
    Fluttertoast.showToast(
      msg: "Falhaste! Tens mais $tentativas tentativas.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 12.0,
    );
  }
}