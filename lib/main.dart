import 'dart:developer';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:mpc_wallet/model/partial_key.dart';
import 'package:mpc_wallet/util/fcm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.',
  // description
  importance: Importance.high,
);

Future<void> main() async {
  print("Launching MPC Wallet...");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // final settings = await FirebaseMessaging.instance.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );

  window.addEventListener("message", (event) {
    print("Event $event");
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MPC Wallet',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const InitiateKeyPage(title: 'MPC Wallet'),
    );
  }
}

class InitiateKeyPage extends StatefulWidget {
  final String title;

  const InitiateKeyPage({Key? key, required this.title}) : super(key: key);

  @override
  _InitiateKeyPageState createState() => _InitiateKeyPageState();
}

class _InitiateKeyPageState extends State<InitiateKeyPage> {
  // final _firebaseMessaging = FirebaseMessaging.instance;

  String _currentDeviceId = "";

  @override
  void initState() {
    super.initState();

    // _firebaseMessaging.getToken().then((token) {
    //   print("Token=$token");
    //   if (token != null) {
    //     setState(() {
    //       _currentDeviceId = token;
    //     });
    //   }
    // });

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   final notification = message.notification;
    //   print("Received: ${message.category}: ${notification?.title}: ${notification?.body}");

    //   if (notification != null && notification.android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.body,
    //         NotificationDetails(
    //           android: AndroidNotificationDetails(
    //             channel.id,
    //             channel.name,
    //             channelDescription: channel.description,
    //             icon: 'launch_background',
    //           ),
    //         ));
    //   }
    // });
  }

  void _sendMessage() async {
    const target =
        "fZ1UNGI4OlLlsFf5BPTJ9X:APA91bHuBLMokCeXX03r8Fyih_35SYzt2IrqSvR4uTzaArsOOfLh2vtzzTQVp2SVKdS-y7Ftp1QgQqqrqeaC-Jbph2nBynR1lGEM2Bzuj0wKW8ivMJP33_4i1oFW9E_XZ3hH2FQ8XohA";
    print("Sending message...");
    // PostFCM.sendMessage(target, "TEST from Web", "correct one");
  }

  @override
  Widget build(BuildContext context) {
    final menuItemNames = ["Settings"];

    final _body = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(_currentDeviceId),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return menuItemNames.map((name) {
              return PopupMenuItem(
                child: Text(name),
                value: name,
              );
            }).toList();
          })
        ],
      ),
      body: _body,
      floatingActionButton: FloatingActionButton(
        key: const Key('send'),
        onPressed: _sendMessage,
        tooltip: 'Send',
        child: const Icon(Icons.send),
      ),
    );
  }
}
