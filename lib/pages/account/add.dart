import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mpc_wallet/main.dart';
import 'package:mpc_wallet/model/account_keyword.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

var _accountAdding = AccountAdding();

bool _joined = false;
bool _created = false;
bool _accountCreated = false;

class AccountAddPage extends StatelessWidget {
  final title = "Add Account";

  const AccountAddPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _goGenerateKeyword() async {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const GenKeyEnterNamePage()));
    }

    void _goEnterKeyword() async {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const EnterKeywordPage()));
    }

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
        key: const Key('next'),
        onPressed: _goEnterMN,
        tooltip: 'Next',
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
        key: const Key('next'),
        onPressed: _goConfirm,
        tooltip: 'Next',
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
        key: const Key('next'),
        onPressed: _goGenerate,
        tooltip: 'Next',
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
    void _goWaitMembersJoin() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const WaitMembersJoinPage()));
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

class WaitMembersJoinPage extends StatelessWidget {
  final title = "Waiting members join";

  const WaitMembersJoinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 10), () {
      if (_joined) {
        log("Already joined");
      } else {
        _joined = true;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MembersJoinedPage()));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Spacer(),
          SpinKitRipple(
            color: Colors.green,
            size: 200,
          ),
          Spacer(),
        ],
      ),
    );
  }
}

class MembersJoinedPage extends StatelessWidget {
  final title = "Joined members";

  const MembersJoinedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _goCreateKey() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const WaitKeyCreatedPage()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Text("All members joined here"),
              const Text("Please confirm name of members"),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Kunio [iMac] (me)"),
                  Text("Nick [Galaxy]"),
                ],
              ),
              const Spacer(),
              const Spacer(),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        key: const Key('next'),
        onPressed: _goCreateKey,
        tooltip: 'Next',
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}

class WaitKeyCreatedPage extends StatelessWidget {
  final title = "Creating key";

  const WaitKeyCreatedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 10), () {
      if (_created) {
        log("Already created");
      } else {
        _created = true;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const KeyCreatedPage()));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Spacer(),
          SpinKitThreeBounce(
            color: Colors.green,
            size: 100,
          ),
          Spacer(),
        ],
      ),
    );
  }
}

class KeyCreatedPage extends StatelessWidget {
  final title = "Key Created";

  final _account = "0x42Eb768f...3153f06";

  const KeyCreatedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final condition = Provider.of<AppCondition>(context);

    void _goHome() {
      Navigator.popUntil(context, (route) {
        return route.settings.name == "/";
      });
      _joined = false;
      _created = false;
      _accountCreated = false;
      condition.addAccount(_account);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Text(
                "Your account just have been created !",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(_account),
              const Spacer(),
              const Text("This account's partial key is stored"),
              const Text("in this device safety."),
              const Spacer(),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Optionally, you can download the key"),
                    const Text("and store it safety place"),
                    ElevatedButton(
                      onPressed: () => {},
                      child: const Text("Download key"),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        key: const Key('home'),
        onPressed: _goHome,
        tooltip: 'Home',
        child: const Icon(Icons.home),
      ),
    );
  }
}

class EnterKeywordPage extends StatefulWidget {
  final title = "Enter keyword";

  const EnterKeywordPage({Key? key}) : super(key: key);

  @override
  _EnterKeywordPageState createState() => _EnterKeywordPageState();
}

class _EnterKeywordPageState extends State<EnterKeywordPage> {
  String _keyword = "";

  @override
  Widget build(BuildContext context) {
    void _goConfirm() {
      final keyword = AccountKeyword.decode(_keyword);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ConfirmKeyDetail(keyword)));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text("Enter shared keyword"),
            TextField(
              onChanged: (text) {
                _keyword = text;
              },
              maxLines: null,
            ),
            const Spacer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('confirm'),
        onPressed: _goConfirm,
        tooltip: 'Confirm',
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}

class ConfirmKeyDetail extends StatelessWidget {
  final title = "Confirm detail";
  final AccountKeyword keyword;

  const ConfirmKeyDetail(this.keyword, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _goWaitAccount() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const WaitAccountCreatedPage()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text("You are joining account bellow"),
            const Spacer(flex: 2),
            const Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(keyword.name),
            const Spacer(),
            const Text("Sign settings",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text("${keyword.m} of ${keyword.n}"),
            const Spacer(flex: 3),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('confirm'),
        onPressed: _goWaitAccount,
        tooltip: 'Confirm',
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}

class WaitAccountCreatedPage extends StatelessWidget {
  final title = "Creating key";

  const WaitAccountCreatedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 30), () {
      if (_accountCreated) {
        log("Already created");
      } else {
        _accountCreated = true;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const KeyCreatedPage()));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Spacer(),
          SpinKitThreeBounce(
            color: Colors.green,
            size: 100,
          ),
          Spacer(),
        ],
      ),
    );
  }
}
