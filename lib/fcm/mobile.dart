import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';

class EventListener {
  void addEventListener(void Function(dynamic e) listen) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      log("Received: ${message.category}: ${notification?.title}: ${notification
          ?.body}");

      if (notification != null) {
        listen(notification);
      }
    });
  }
}

late final listener = EventListener();
