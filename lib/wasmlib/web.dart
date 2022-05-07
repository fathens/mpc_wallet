@JS()
library wasmlib.web;

import 'dart:js_util';
import 'package:js/js.dart';

@JS()
abstract class Promise<T> {
  external factory Promise(
      void executor(void resolve(T result), Function reject));

  external Promise then(void onFulfilled(T result), [Function onRejected]);
}

@JS('init')
external Promise<void> _init();

@JS('calc_add')
external int calc_add(int a, int b);

class WasmlibWeb {
  static var _hasInit = false;

  static Future<void> _initWASM() async {
    if (_hasInit) return;
    await promiseToFuture(_init());
    _hasInit = true;
  }

  Future<int> calcAdd({required int a, required int b, dynamic hint}) async {
    await _initWASM();
    return calc_add(a, b);
  }
}

late final api = WasmlibWeb();
