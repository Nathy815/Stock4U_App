import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/usuarioService.dart';
import 'login.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
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
            return StreamBuilder<User>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active)
                  return Home();
                else if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                else
                  return Login();
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