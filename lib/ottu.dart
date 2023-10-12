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
    String merchantid,
    PaymentDelegate paymentDelegate, {
    /// It is optional. It takes default language en.
    String? lang,
  }) async {
    try {
      await NetworkUtils.getPaymentDetails(
        sessionId,
        openScreen: (e) {},
        context: context,
        paymentDelegate: paymentDelegate,
        sdkLanguage: lang!,
        apikey: apiKey,
        merchantId: merchantid,
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}
