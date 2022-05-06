import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mpc_wallet/pages/sample/messaging.dart';
import 'package:mpc_wallet/pages/sample/rustuse.dart';

Future<void> main() async {
  log("Launching MPC Wallet...");

  WidgetsFlutterBinding.ensureInitialized();

  await initFirebase();

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
      routes: {
        "/messaging": (context) => const MessagingPage(),
        "/calc": (context) => const RustCalcPage(),
      },
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final menuItemNames = {
      "Messaging": "/messaging",
      "Calc": "/calc",
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return menuItemNames.keys.map((name) {
                return PopupMenuItem(
                  child: Text(name),
                  value: menuItemNames[name],
                );
              }).toList();
            },
            onSelected: (value) {
              Navigator.pushNamed(context, value.toString());
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            // Add something
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('add'),
        onPressed: () => {},
        tooltip: 'Send',
        child: const Icon(Icons.add),
      ),
    );
  }
}
