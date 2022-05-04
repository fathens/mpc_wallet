import 'dart:developer';
import 'dart:html';
import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:mpc_wallet/model/partial_key.dart';
import 'package:mpc_wallet/util/fcm.dart';
import 'package:mpc_wallet/util/wasmlib.dart';
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

Future<void> initWASM() async {
  await promiseToFuture(init());
}

Future<void> main() async {
  print("Launching MPC Wallet...");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print("Loading FirebaseMessaging...");
  final settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print("Subscribe event 'message' of window");
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
  final _firebaseMessaging = FirebaseMessaging.instance;

  String _currentDeviceId = "";
  String _destinationDevice = "";
  String _message = "";

  @override
  void initState() {
    super.initState();

    _firebaseMessaging.getToken().then((token) {
      print("Token=$token");
      if (token != null) {
        setState(() {
          _currentDeviceId = token;
        });
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      print("Received: ${message.category}: ${notification?.title}: ${notification?.body}");

      if (notification != null && notification.android != null) {
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
    });
  }

  void _sendMessage() async {
    String target = _destinationDevice;
    print("Sending message to $target");
    PostFCM.sendMessage(target, "TEST from Web", _message);
  }

  void _calc_add() async {
    await initWASM();
    print("WASM initialized.");

    final c = calc_add(1, 2);
    print("Calc ADD: 1 + 2 = $c");
  }

  @override
  Widget build(BuildContext context) {
    final menuItemNames = ["Settings"];

    final _body = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("ME"),
          SelectableText(_currentDeviceId),
          const Text("Destination"),
          TextField(onChanged: (text) {
            _destinationDevice = text;
          }),
          const Text("Message"),
          TextField(onChanged: (text) {
            _message = text;
          }),
          ElevatedButton(onPressed: _calc_add, child: const Text("Calc ADD"))
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
