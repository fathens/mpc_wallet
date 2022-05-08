import 'dart:developer';
import 'dart:html' as html;

class EventLister {
  void addEventLister(void Function(dynamic e) listen) {
    html.window.navigator.serviceWorker?.addEventListener("message", (event) {
      log("Event from ServiceWorker: $event");
      listen(event);
    });
    listen("registered");
  }
}

late final listner = EventLister();
