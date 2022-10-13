import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show Encoding, json;
import 'package:firebase_core/firebase_core.dart';
import 'package:mpc_wallet/firebase_options.dart';

import 'mobile.dart' if (dart.library.html) 'web.dart' as fcmListener;

late final listener = fcmListener.listener;

final _postUrl = Uri.parse('https://fcm.googleapis.com/fcm/send');

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

Future<String> getDeviceToken() async {
  String? token;
  while (token == null) {
    log("Getting device token of Firebase....");
    token = await FirebaseMessaging.instance.getToken();
  }
  return token;
}

void addEventListener(void Function(dynamic e) listen) {
  listener.addEventListener(listen);
}

class PostFCM {
  static const _serverKey =
      "AAAA0o7mYxs:APA91bFGE8yQfBV6HT29_E98FRyJq72AUQ0DtUbG-WZmOGOKXmElEgrO9ppBaDjYcHkJPPWiz2n1z3jElNNC1ONhPz66cQnwN1mNt1LniFIZnmk2C0QQNAZ7LrPh12OC-iCbUwDoVJkE";

  static Future<bool> sendMessage(String to, String title, String body) async {
    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=$_serverKey'
    };

    final data = {
      "notification": {"body": body, "title": title},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done"
      },
      "to": to,
    };

    final response = await http.post(_postUrl,
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do sth
      return true;
    } else {
      // on failure do sth
      return false;
    }
  }
}
