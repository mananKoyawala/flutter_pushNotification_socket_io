import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socket_io_basics/Screens/Message.dart';
import 'package:socket_io_basics/Screens/PushNotifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';

//function to lisen to background changes
final nKey = GlobalKey<NavigatorState>();

// To Handle Background Notifications
Future firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    // print("Notification is received: ");
  }
}

firebaseNotificationHandler() async {
  //on background notification tapped
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      Navigator.push(
          nKey.currentContext!,
          MaterialPageRoute(
              builder: (_) => MessageScreen(
                    data: message,
                  )));
    }
  });

  PushNotifications.intt();
  PushNotifications.localNotiInit();
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessage);

  //Foreground notifications
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadData = jsonEncode(message.data);
    if (message.notification != null) {
      PushNotifications.showSimpleNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: payloadData);
    }
  });

  // Notification tapped when app is terminated
}

onTerminatedNotificationHandler() async {
  final RemoteMessage? message =
      await FirebaseMessaging.instance.getInitialMessage();

  if (message != null) {
    Future.delayed(const Duration(milliseconds: 0), () {
      Navigator.push(
          nKey.currentContext!,
          MaterialPageRoute(
              builder: (_) => MessageScreen(
                    data: message,
                  )));
    });
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // When app is terminated state
  onTerminatedNotificationHandler();

  firebaseNotificationHandler();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      navigatorKey: nKey,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Container(
        alignment: Alignment.center,
        child: const Text(
          'Hello',
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
    );
  }
}
