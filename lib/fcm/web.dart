import 'dart:developer';
import 'dart:html';

class EventLister {
  void addEventLister(void Function(dynamic e) listen) {
    const nav = ServiceWorkerContainer.messageEvent;
    log("navigator: $nav");
    nav.forTarget(null).listen((event) {
      listen(event);
    });
  }
}

late final listner = EventLister();
