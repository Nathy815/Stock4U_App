import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/usuarioService.dart';
import 'login.dart';
import 'home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock4U',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        key: _scaffoldKey,
        body: MessageHandler()
      )
    );
  }
}

class MessageHandler extends StatefulWidget {
  @override
  createState() => MessageHandlerState();
}

class MessageHandlerState extends State<MessageHandler> {
  final FirebaseMessaging _messaging = new FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: " + message.toString());
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Color.fromRGBO(250, 250, 250, 1),
          icon: Icon(
            Icons.warning_outlined,
            color: Color.fromRGBO(215, 0, 0, 1)
          ),
          leftBarIndicatorColor: Color.fromRGBO(215, 0, 0, 1),
          boxShadows: [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(0.0, 0.2),
              blurRadius: 3.0
            )
          ],
          padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 30),
          duration: Duration(seconds: 5),
          dismissDirection: FlushbarDismissDirection.HORIZONTAL,
          titleText: Text(
            message['notification']['title'].toString(),
            style: TextStyle(
              color: Color.fromRGBO(215, 0, 0, 1),
              fontWeight: FontWeight.w500
            )
          ),
          messageText: Text(
            message['notification']['body'].toString(),
            style: TextStyle(
              color: Colors.black45
            ),
          )
        )..show(context);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("OnLaunch: " + message.toString());
      },
      onResume: (Map<String, dynamic> message) async {
        print("OnResume: " + message.toString());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock4U',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AnimatedSplashScreen(
        duration: 1000,
        splash: Text(
          'Stock4U',
          style: TextStyle(
            color: Color.fromRGBO(215, 0, 0, 1),
            fontSize: 72,
            fontWeight: FontWeight.w500
          )
        ),
        nextScreen: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            return FutureBuilder<bool>(
              future: UsuarioService().isAuthenticated(),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                {
                  if (snapshot.data == true)
                    return Home();
                  else
                    return Login();
                }
                else
                  return Center(child: CircularProgressIndicator());
              }
            );
          },
        ),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.scale,
        backgroundColor: Colors.white
      ),
    );
  }
}