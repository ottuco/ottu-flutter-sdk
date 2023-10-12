import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ottu/Networkutils/networkUtils.dart';
import 'package:ottu/applePay/paymentItem.dart';
import 'package:ottu/applePay/paymentNetwork.dart';
import 'package:ottu/models/applePayModel.dart';
import './ottuPaymentError.dart' show OttuPaymentError;

class ApplePay {
  Future<String> pay(String amount, String merchantIdentifier, String currencyCode, countryCode, BuildContext context) async {
    List<PaymentItem> items = [
      PaymentItem(
        name: "",
        price: double.parse(amount),
      )
    ];
    return requestPayment(
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

  Future<String> requestPayment({
    AppleParameters? appleParameters,
    List<PaymentNetwork> allowedPaymentNetworks = const [],
    required List<PaymentItem> paymentItems,
    bool emailRequired = false,
    required String currencyCode,
    required String countryCode,
  }) async {
    var items = paymentItems.map((item) => item.toJson()).toList();
    var params = <String, dynamic>{
      "currencyCode": currencyCode,
      "countryCode": countryCode,
      "allowedPaymentNetworks": allowedPaymentNetworks.map((network) => network.getName).toList(),
      "items": items,
      "emailRequired": emailRequired,
    };

    if (Platform.isIOS && appleParameters != null) {
      params.addAll(appleParameters.toMap());
    } else {
      throw OttuPaymentError(description: "");
    }

    try {
      const MethodChannel channel = MethodChannel('ottu');
      var response = await channel.invokeMethod('requestPayment', params);
      var payResponse = Map<String, String>.from(response);
      if (payResponse == null) {
        throw OttuPaymentError(description: "Pay response cannot be parsed");
      }

      var paymentToken = payResponse["token"];
      if (paymentToken != null) {
        if (kDebugMode) {}
        return paymentToken;
      } else {
        if (kDebugMode) {
          //print("Payment token: null");
        }
        return "";
      }
    } on PlatformException catch (error) {
      if (error.code == "userCancelledError") {
        if (kDebugMode) {
          //print(error.message);
        }
        return "";
      }
      if (error.code == "paymentError") {
        if (kDebugMode) {
          //print(error.message);
        }
        return "";
      }
      throw OttuPaymentError(code: error.code, description: error.message);
    }
  }
}
