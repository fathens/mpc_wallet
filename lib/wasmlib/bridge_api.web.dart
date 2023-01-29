// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:mpc_wallet/bridge_generated.dart';
import 'package:mpc_wallet/bridge_generated.web.dart';

const root = 'pkg/wasmlib';

Future<WasmModule> _initModule() {
  if (crossOriginIsolated != true) {
    return Future.error(const MissingHeaderException());
  }

  final script = ScriptElement()..src = '$root.js';
  document.head!.append(script);
  return script.onLoad.first.then((_) {
    eval("window.wasm_bindgen = wasm_bindgen");
    return wasmModule.bind(wasmModule, '${root}_bg.wasm');
  });
}

final api = WasmlibImpl.wasm(_initModule());