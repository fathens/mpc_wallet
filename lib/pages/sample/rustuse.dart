import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mpc_wallet/wasmlib/bridge_api.dart';

class RustCalcPage extends StatefulWidget {
  final title = "Calc by Rust";

  const RustCalcPage({Key? key}) : super(key: key);

  @override
  _RustCalcPageState createState() => _RustCalcPageState();
}

class _RustCalcPageState extends State<RustCalcPage> {
  String _addedValue = "0";

  void _calcAdd() async {
    final c = await api.calcAdd(a: 1, b: 2);
    log("Calc ADD: 1 + 2 = $c");
    setState(() {
      _addedValue = "1 + 2 = $c";
    });
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
            ElevatedButton(onPressed: _calcAdd, child: const Text("Calc ADD")),
            Text(_addedValue)
          ],
        ),
      ),
    );
  }
}
