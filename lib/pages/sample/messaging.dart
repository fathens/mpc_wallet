import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mpc_wallet/fcm/facade.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

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
  String _deviceToken = "";
  String _destinationDevice = "";
  String _messageTitle = "";
  String _messageBody = "";

  void _initToken() async {
    final token = await getDeviceToken();
    setState(() {
      _deviceToken = token;
    });
    log("Empty device token.");
  }

  void _startToListen() async {
    addEventListener((e) => _getNotify(e));
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

  final _deviceTextField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("ME", style: TextStyle(fontWeight: FontWeight.bold)),
            SelectableText(_deviceToken),
            const Padding(padding: EdgeInsets.fromLTRB(0, 50, 0, 0)),
            const Text("Destination",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _deviceTextField,
              onChanged: (text) {
                _destinationDevice = text;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
            ElevatedButton(
                onPressed: () => setState(() {
                      _deviceTextField.clear();
                      _destinationDevice = "";
                    }),
                child: const Text("Clear")),
            const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
            const Text("Message Title"),
            TextField(onChanged: (text) {
              _messageTitle = text;
            }),
            const Text("Message Body"),
            TextField(onChanged: (text) {
              _messageBody = text;
            }),
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
