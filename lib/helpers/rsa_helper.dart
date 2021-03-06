import 'package:pointycastle/asymmetric/api.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RSAHelper {
  late Future<AsymmetricKeyPair> futureKeyPair;
  late AsymmetricKeyPair keyPair;
  RsaKeyHelper helper = RsaKeyHelper();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<AsymmetricKeyPair<PublicKey, PrivateKey>> getKeyPair()
  {
    return helper.computeRSAKeyPair(helper.getSecureRandom());
  }

  Future<String> generateKeyPair(username) async {
    futureKeyPair = getKeyPair();
    keyPair = await futureKeyPair;
    var publicKey = keyPair.publicKey as RSAPublicKey;
    var privateKey = keyPair.privateKey as RSAPrivateKey;
    String stringPublicKey = RsaKeyHelper().encodePublicKeyToPemPKCS1(publicKey);
    String stringPrivateKey = RsaKeyHelper().encodePrivateKeyToPemPKCS1(privateKey);
    await storage.write(key: 'private-'+username, value: stringPrivateKey);
    await storage.write(key: 'public-'+username, value: stringPublicKey);
    return stringPublicKey;
  }

  Future<String> decryptMessage(message) async {
    print('encrypted input: ' + message);
    String username = await storage.read(key: 'logged-as') as String;
    var privateKeyString = await storage.read(key: 'private-'+username);
    // print('private key: ' + privateKeyString!);
    var privateKey = helper.parsePrivateKeyFromPem(privateKeyString);
    String decrypted = decrypt(message, privateKey);
    print('decrypted output: ' + decrypted);
    return decrypted;
    // #TODO obsługa błędu odszyfrowywania
  }

  Future<String> encryptMessage(message, publicKeyString) async {
    var publicKey = helper.parsePublicKeyFromPem(publicKeyString);
    var encryptedMessage = encrypt(message, publicKey);
    return encryptedMessage;
  }
}