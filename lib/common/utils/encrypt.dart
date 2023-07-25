// import 'package:cryptography/cryptography.dart';

import 'dart:convert';
import 'package:crypto/crypto.dart';

/// 加密类
class EncryptUtil {
  static final EncryptUtil _instance = EncryptUtil._internal();
  factory EncryptUtil() => _instance;
  EncryptUtil._internal();

  // sha256
  Future<String> sha(String password) async {
    if (password.isEmpty) {
      return "";
    }

    // const nonce = publicRuntimeConfig.nonceSecret;
    // let privateKey = publicRuntimeConfig.privateKey;

    // console.log("nonce", nonce);
    // console.log("privateKey", privateKey);

    const nonce = "FEocxASkEFDmGn89";
    // const privateKey = "TjrXDG8TuvopEoxNekVgMXMZB6b7Gswo";

    password = password.trim();
    var shaPassword = sha256.convert(utf8.encode(nonce + password));
    return shaPassword.toString();

    // var shaPassword = await Sha256().hash(utf8.encode(nonce + password));
    // return shaPassword.toString();
    // var shaPrivateKey = await Sha256().hash(utf8.encode(privateKey));
    // var hmacValue = await Hmac.sha512().calculateMac(
    //   shaPassword.bytes,
    //   secretKey: SecretKey(shaPrivateKey.bytes),
    // );
    // var result = base64.encode(hmacValue.bytes);
    // return result;
  }
}
