import 'dart:convert';
import 'package:signer/signer.dart';
import 'package:hex/hex.dart';

Future<Signer> createSigner(String mnemonicOrSeed, KPType keypairType) async {
  final Signer signer = Signer();
  await signer.fromUri(mnemonicOrSeed, keypairType);
  return signer;
}

String createSignatureForChallenge(Signer signer, String challenge) {
  final signature = signer.sign(challenge);
  return base64Encode(HEX.decode(signature));
}

Future<String> createSignatureWithPublicKey(
    int timestamp, String publicKey, Signer signer) async {
  final challenge = '$timestamp:$publicKey';
  return await createSignatureForChallenge(signer, challenge);
}

Future<Map<String, String>> createAuthHeader(
    int twinID, String mnemonicOrSeed, KPType keypairType) async {
  final signer = await createSigner(mnemonicOrSeed, keypairType);
  int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  final challenge = '$timestamp:$twinID';
  final signature = await createSignatureForChallenge(signer, challenge);
  return {
    'X-Auth': '${base64Encode(challenge.codeUnits)}:${signature}',
  };
}

Future<String> derivePublicKey(
    String mnemonicOrSeed, KPType keypairType) async {
  final signer = await createSigner(mnemonicOrSeed, keypairType);
  final publicKey = signer.keypair!.publicKey.bytes;
  return base64Encode(publicKey);
}

bool isValidSeed(String seed) {
  final RegExp hexRegex = RegExp(r'(0[xX])?[0-9a-fA-F]+');
  return hexRegex.hasMatch(seed);
}
