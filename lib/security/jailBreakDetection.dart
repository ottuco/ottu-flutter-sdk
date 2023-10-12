// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

///To detect jailbreacked device
class NotSecureDevice {
  Future<bool> checkSecureDevice(BuildContext context) async {
    bool jailbroken = await FlutterJailbreakDetection.jailbroken;
    bool isJailBreak = jailbroken;
    if (jailbroken) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your device is not secure.'),
          backgroundColor: Colors.red,
        ),
      );
    }
    return isJailBreak;
  }
}
