import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mpc_wallet/pages/account/add.dart';
import 'package:mpc_wallet/pages/sample/messaging.dart';
import 'package:mpc_wallet/pages/sample/rustuse.dart';
import 'package:mpc_wallet/pages/sample/wallet_connect.dart';
import 'package:mpc_wallet/fcm/facade.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  log("Launching MPC Wallet...");

  WidgetsFlutterBinding.ensureInitialized();

  await initFirebase();

  runApp(ChangeNotifierProvider(
    create: (_) => AppCondition(),
    child: const MyApp(),
  ));
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
      home: const AccountListPage(title: 'MPC Wallet'),
      routes: {
        "/wallet_connect": (context) => const WalletConnectPage(),
        "/messaging": (context) => const MessagingPage(),
        "/calc": (context) => const RustCalcPage(),
      },
    );
  }
}

class AppCondition with ChangeNotifier {
  final List<String> accounts = List.empty(growable: true);

  AppCondition() {
    addEventListener((event) {
      log("Get Event: $event");
    });
  }

  void addAccount(String addr) {
    accounts.add(addr);
    notifyListeners();
  }
}

class AccountListPage extends StatefulWidget {
  final String title;

  const AccountListPage({Key? key, required this.title}) : super(key: key);

  @override
  _AccountListPageState createState() => _AccountListPageState();
}

class _AccountListPageState extends State<AccountListPage> {
  @override
  void initState() {
    super.initState();
  }

  final menuItemNames = {
    "WalletConnect": "/wallet_connect",
    "Messaging": "/messaging",
    "Calc": "/calc",
  };

  @override
  Widget build(BuildContext context) {
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
        child: ListView(
          children: Provider.of<AppCondition>(context).accounts.map((account) {
            return ListTile(
              leading: const Icon(Icons.send),
              title: Text(account),
              trailing: const Icon(Icons.more_vert),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('add'),
        onPressed: _goAccountAdd,
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _goAccountAdd() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AccountAddPage()));
  }
}
