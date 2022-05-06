import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mpc_wallet/util/fcm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mpc_wallet/firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

Future<void> initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  log("Loading FirebaseMessaging...");
  final settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  log("Loaded FirebaseMessaging: $settings");
}

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.',
  // description
  importance: Importance.high,
);

void _getNotify(RemoteNotification notification) async {
  if (TargetPlatform.android == defaultTargetPlatform) {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: 'launch_background',
          ),
        ));
  }
}

class MessagingPage extends StatefulWidget {
  final title = "Messaging";

  const MessagingPage({Key? key}) : super(key: key);

  @override
  _MessagingPageState createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  final _firebaseMessaging = FirebaseMessaging.instance;

  String _deviceToken = "";
  String _destinationDevice = "";
  String _messageTitle = "";
  String _messageBody = "";

  void _initToken() async {
    final token = await _firebaseMessaging.getToken();
    if (token != null) {
      setState(() {
        _deviceToken = token;
      });
    }
    log("Empty device token.");
  }

  void _startToListen() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      log("Received: ${message.category}: ${notification?.title}: ${notification?.body}");

      if (notification != null) {
        _getNotify(notification);
      }
    });
  }

  void _sendMessage() async {
    String target = _destinationDevice;
    log("Sending message to $target");
    PostFCM.sendMessage(target, _messageTitle, _messageBody);
  }

  @override
  void initState() {
    super.initState();

    _initToken();
    _startToListen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("ME"),
            SelectableText(_deviceToken),
            const Spacer(),
            const Text("Destination"),
            TextField(onChanged: (text) {
              _destinationDevice = text;
            }),
            const Spacer(),
            const Text("Message Title"),
            TextField(onChanged: (text) {
              _messageTitle = text;
            }),
            const Text("Message Body"),
            TextField(onChanged: (text) {
              _messageBody = text;
            }),
            const Spacer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('send'),
        onPressed: _sendMessage,
        tooltip: 'Send',
        child: const Icon(Icons.send),
      ),
    );
  }
}
