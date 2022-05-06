import 'dart:convert';
import 'dart:developer';

import 'package:mpc_wallet/util/fcm.dart';

class AccountAdding {
  String name = "";
  int m = 0;
  int n = 0;

  @override
  String toString() {
    return "$name ($m of $n)";
  }
}

class AccountKeyword {
  static Future<AccountKeyword> generate(AccountAdding src) async {
    log("Generating keyword from info: $src}");
    final token = await getDeviceToken();
    return AccountKeyword(src.name, src.m, src.n, token);
  }

  static AccountKeyword decode(String keyword) {
    final bytes = base64Decode(keyword);
    final nameLen = bytes.first;
    final nameBytes = bytes.sublist(1, nameLen + 1);
    final name = utf8.decode(nameBytes);

    final mnToken = bytes.sublist(nameLen + 1);
    final m = mnToken.first;
    final n = mnToken.sublist(1).first;
    final token = utf8.decode(mnToken.sublist(2));

    return AccountKeyword(name, m, n, token);
  }

  final String name;
  final int m, n;
  final String deviceToken;

  const AccountKeyword(this.name, this.m, this.n, this.deviceToken);

  String encode() {
    List<int> result = List.empty(growable: true);
    final nameBytes = utf8.encode(name);
    result.add(nameBytes.length);
    result.addAll(nameBytes);
    result.add(m);
    result.add(n);
    result.addAll(utf8.encode(deviceToken));
    return base64Encode(result);
  }
}