import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

String generateRandomTokenWithValidity({
  int length = 32,
  Duration validityDuration = const Duration(
    minutes: 30,
  ),
}) {
  final Uint8List randomBytes = getRandomBytes(length);

  // Add the current timestamp to the payload
  final int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
  final Map<String, dynamic> payload = {
    'token': base64Url.encode(randomBytes),
    'exp': (currentTimestamp + validityDuration.inMilliseconds) ~/ 1000,
  };

  final String base64String =
      base64Url.encode(utf8.encode(json.encode(payload)));

  return base64String;
}

String _generateHmacSignature(String data) {
  // Ideally, this key SHOULD NOT be hardcoded here
  final secretKey =
      utf8.encode('my_secret_encryption_key_received_from_backend');
  final hmac = Hmac(sha256, secretKey);
  final digest = hmac.convert(utf8.encode(data));
  return base64Url.encode(digest.bytes);
}

Uint8List getRandomBytes(int length) {
  final Uint8List randomBytes = Uint8List(length);
  final Random random = Random.secure();
  for (int i = 0; i < length; i++) {
    randomBytes[i] = random.nextInt(256);
  }
  return randomBytes;
}

String decryptToken(String token) {
  final List<String> parts = token.split('.');
  if (parts.length != 2) {
    throw Exception('Invalid token format');
  }

  final String payloadString = parts[0];
  final String receivedSignature = parts[1];

  final String expectedSignature = _generateHmacSignature(payloadString);

  if (expectedSignature != receivedSignature) {
    throw Exception('Invalid token');
  }

  final Map<String, dynamic> payload =
      json.decode(utf8.decode(base64Url.decode(payloadString)));

  if (!payload.containsKey('exp') || payload['exp'] is! int) {
    throw Exception('Invalid token expiration');
  }

  final int expirationTimestamp = payload['exp'];

  if (!isTokenValid(expirationTimestamp)) {
    throw Exception('Token expired');
  }

  return payloadString;
}

bool isTokenValid(int expirationTimestamp) {
  final int currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  return currentTimestamp < expirationTimestamp;
}
