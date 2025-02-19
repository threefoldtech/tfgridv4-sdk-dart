import 'dart:convert';
import 'package:pinenacl/ed25519.dart';

String createSignatureForChallenge(String challenge, String privateKey) {
  final privateKeyBytes = base64Decode(privateKey);
  final signature = SigningKey(seed: privateKeyBytes.sublist(0, 32))
      .sign(Uint8List.fromList(challenge.codeUnits));
  return base64Encode(signature.signature);
}

String createSignatureWithPublicKey(
    int timestamp, String publicKey, String privateKey) {
  final challenge = '$timestamp:$publicKey';
  return createSignatureForChallenge(challenge, privateKey);
}

Map<String, String> createAuthHeader(int twinID, String privateKey) {
  int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  final challenge = '$timestamp:$twinID';
  final signature = createSignatureForChallenge(challenge, privateKey);
  return {
    'X-Auth': '${base64Encode(challenge.codeUnits)}:${signature}',
  };
}

String derivePublicKey(String privateKey) {
  final privateKeyBytes = base64Decode(privateKey);
  final publicKey = SigningKey(seed: privateKeyBytes.sublist(0, 32)).verifyKey;
  return base64Encode(publicKey);
}
