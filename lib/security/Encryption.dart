import 'package:basic_utils/basic_utils.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pem/pem.dart';

class EncrypData {
  String encrypt(String data, String publicKey) {
    List<int> keyData = PemCodec(PemLabel.publicKey).decode("""
  -----BEGIN PUBLIC KEY-----
  $publicKey
  -----END PUBLIC KEY-----
""");

// Encode keyData as PEM string.
    String pemBlock = PemCodec(PemLabel.publicKey).encode(keyData);

    var a = RSAKeyParser().parse(pemBlock);
    var b = Encrypter(RSA(
        publicKey: RSAPublicKey(a.modulus!, a.exponent!),
        encoding: RSAEncoding.OAEP));
    var c = b.encrypt(data);
    return c.base16;
  }
}
