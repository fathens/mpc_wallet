import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

class WalletConnectPage extends StatefulWidget {
  final title = "WalletConnect";

  const WalletConnectPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WalletConnectPageState();
}

class _WalletConnectPageState extends State<WalletConnectPage> {
  String _url = "";

  @override
  Widget build(BuildContext context) {
    void goConnect() async {
      if (_url.isEmpty) {
        Fluttertoast.showToast(msg: "Enter URL");
        return;
      }
      _targetUrl = _url;
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ConnectingPage()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Enter target url"),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: TextField(onChanged: (text) {
              _url = text;
            }),
          ),
          const Spacer(),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        key: const Key('connect'),
        onPressed: goConnect,
        tooltip: 'Connect',
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}

String _targetUrl = "";

class ConnectingPage extends StatefulWidget {
  final title = "Connecting";

  const ConnectingPage({Key? key}) : super(key: key);

  @override
  ConnectingPageState createState() => ConnectingPageState();
}

class ConnectingPageState extends State<ConnectingPage> {
  @override
  Widget build(BuildContext context) {
    void goOK() async {
      // Create a connector
      final connector = WalletConnect(
        uri: _targetUrl,
        clientMeta: const PeerMeta(
          name: 'WalletConnect',
          description: 'WalletConnect Developer App',
          url: 'https://walletconnect.org',
          icons: [
            'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
          ],
        ),
      );
      // Subscribe to events
      connector.on('connect', (session) =>
        debugPrint("WalletConnect: connected: $session"));
      connector.on('session_request', (payload) =>
        debugPrint("WalletConnect: session requested: $payload"));
      connector.on('disconnect', (session) =>
        debugPrint("WalletConnect: disconnected: $session"));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(_targetUrl),
            ),
            const Spacer()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('OK'),
        onPressed: goOK,
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
