import 'package:flutter_test/flutter_test.dart';
import 'package:mpc_wallet/model/account_keyword.dart';

void main() {
  test("Encode/Decode", () {
    const original = AccountKeyword("ABC", 2, 3, "argpiqrASDgquiiAFG");
    final encoded = original.encode();
    final decoded = AccountKeyword.decode(encoded);

    expect(decoded.name, original.name);
    expect(decoded.m, original.m);
    expect(decoded.n, original.n);
    expect(decoded.deviceToken, original.deviceToken);
  });
}