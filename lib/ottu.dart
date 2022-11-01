import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:ottu/Networkutils/networkUtils.dart';
import 'package:ottu/paymentDelegate/paymentDelegate.dart';

/// ottu payment sdk
class Ottu {
  /// Add context,paymentDelegate's object and sessionID in [open] method to initialize SDK.
  Future open(
    BuildContext context,
    String sessionId,
    String apiKey,
    PaymentDelegate paymentDelegate, {

    /// It is optional. It takes default language en.
    String? sdkLanguage,
  }) async {
    try {
      await NetworkUtils.fetchPaymentTransaction(
        sessionId,
        openScreen: (e) {},
        context: context,
        paymentDelegate: paymentDelegate,
        sdkLanguage: sdkLanguage!,
        apikey: apiKey,
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}
