import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mpc_wallet/model/account_keyword.dart';

var _accountAdding = AccountAdding();

class AccountAddPage extends StatelessWidget {
  final title = "Add Account";

  const AccountAddPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _goGenerateKeyword() async {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const GenKeyEnterNamePage()));
    }

    void _goEnterKeyword() async {}

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text("You need to have keyword to generate account"),
            const Spacer(),
            const Text("No. I do not have keyword yet"),
            ElevatedButton(
                onPressed: _goGenerateKeyword,
                child: const Text("Generate keyword")),
            const Spacer(),
            const Text("Yes. I have keyword already"),
            ElevatedButton(
                onPressed: _goEnterKeyword, child: const Text("Enter keyword")),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class GenKeyEnterNamePage extends StatefulWidget {
  final title = "Generate keyword";

  const GenKeyEnterNamePage({Key? key}) : super(key: key);

  @override
  _GenKeyEnterNamePageState createState() => _GenKeyEnterNamePageState();
}

class _GenKeyEnterNamePageState extends State<GenKeyEnterNamePage> {
  String _name = "";

  @override
  Widget build(BuildContext context) {
    void _goEnterMN() async {
      if (_name.isNotEmpty) {
        _accountAdding.name = _name;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const GenKeyEnterMNPage()));
      } else {
        Fluttertoast.showToast(msg: "Enter the name");
      }
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
            const Text("Enter new account name"),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextField(onChanged: (text) {
                _name = text;
              }),
            ),
            const Spacer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('send'),
        onPressed: _goEnterMN,
        tooltip: 'Send',
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}

class GenKeyEnterMNPage extends StatefulWidget {
  final title = "Generate keyword";

  const GenKeyEnterMNPage({Key? key}) : super(key: key);

  @override
  _GenKeyEnterMNPageState createState() => _GenKeyEnterMNPageState();
}

class _GenKeyEnterMNPageState extends State<GenKeyEnterMNPage> {
  int _m = 0;
  int _n = 0;

  @override
  Widget build(BuildContext context) {
    void _goConfirm() async {
      if (_m > 0 && _n > 0) {
        _accountAdding.m = _m;
        _accountAdding.n = _n;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const GenKeyConfirmPage()));
      } else {
        Fluttertoast.showToast(msg: "Enter the numbers");
      }
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
            const Text("Number of members"),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextFormField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (text) {
                    final v = int.tryParse(text);
                    if (v != null) {
                      _n = v;
                    }
                  }),
            ),
            const Spacer(),
            const Text("Minimum number of signatures"),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextFormField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (text) {
                    final v = int.tryParse(text);
                    if (v != null) {
                      _m = v;
                    }
                  }),
            ),
            const Spacer(),
            const Spacer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('send'),
        onPressed: _goConfirm,
        tooltip: 'Send',
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}

class GenKeyConfirmPage extends StatelessWidget {
  final title = "Generate keyword";

  const GenKeyConfirmPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _goGenerate() async {
      final keyword = await AccountKeyword.generate(_accountAdding);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GeneratedKeywordPage(keyword)));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Text("Generating account"),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Name: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(_accountAdding.name),
                  const Spacer(),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Sign: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("${_accountAdding.m} of ${_accountAdding.n}"),
                  const Spacer(),
                ],
              ),
              const Spacer(),
              const Spacer(),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        key: const Key('send'),
        onPressed: _goGenerate,
        tooltip: 'Send',
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}

class GeneratedKeywordPage extends StatelessWidget {
  final title = "Generate keyword";
  final AccountKeyword keyword;

  const GeneratedKeywordPage(this.keyword, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _goWaitMembersJoin() {}

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Text("Generated keyword"),
              const Spacer(),
              SelectableText(keyword.encode()),
              const Spacer(),
              const Text("Please share this keyword"),
              const Text("with the other members secretly"),
              ElevatedButton(
                  onPressed: _goWaitMembersJoin,
                  child: const Text("OK. I shared this keyword")),
              const Spacer(),
            ],
          )),
    );
  }
}
