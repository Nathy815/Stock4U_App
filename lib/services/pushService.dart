import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushService {
  final FirebaseMessaging _notification;

  PushService(this._notification);

  Future initialize(BuildContext context) async {
    _notification.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: " + message.toString());
        /*Scaffold.of(context).showSnackBar(new SnackBar(
          content: ListTile(
            title: message['notification']['title'],
            subtitle: message['notification']['body']
          ),
          action: SnackBarAction(
            label: "OK",
            onPressed: () => null,
          ),
        ));*/
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("OnLaunch: " + message.toString());
      },
      onResume: (Map<String, dynamic> message) async {
        print("OnResume: " + message.toString());
      },
    );
  }
}