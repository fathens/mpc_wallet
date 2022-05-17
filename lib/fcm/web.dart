import 'dart:developer';
import 'dart:html' as html;

class EventListener {
  void addEventListener(void Function(dynamic e) listen) {
    html.window.navigator.serviceWorker?.addEventListener("message", (event) {
      log("Event from ServiceWorker: $event");
      listen(event);
    });
    listen("registered");
  }
}

late final listener = EventListener();
