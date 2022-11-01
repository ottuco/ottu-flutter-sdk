import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pay/flutter_pay.dart';
import 'package:ottu/Networkutils/networkUtils.dart';

class ApplePay {
  FlutterPay flutterPay = FlutterPay();
  Future<String> pay(String amount, String merchantIdentifier,
      String currencyCode, countryCode, BuildContext context) async {
    List<PaymentItem> items = [
      PaymentItem(
        name: "",
        price: double.parse(amount),
      )
    ];
    flutterPay.setEnvironment(environment: PaymentEnvironment.Test);
    return flutterPay.requestPayment(
      appleParameters: AppleParameters(
        merchantIdentifier: merchantIdentifier,
      ),
      currencyCode: currencyCode,
      countryCode: countryCode,
      paymentItems: items,
    );
  }

  void paywithApple(
    String validationUrl,
    BuildContext context,
    String currencyCode,
    String countryCode,
    String amount,
    String merchantIdentifier,
    String paymenturl,
  ) async {
    NetworkUtils.applePayvalidationUrl(
      validationUrl,
      paymenturl,
      amount,
      context,
      currencyCode,
      countryCode,
      merchantIdentifier,
    );
  }
}
