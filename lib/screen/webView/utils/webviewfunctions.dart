import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ottu/Networkutils/networkUtils.dart';

///webview controllers
class WebViewFunctions {
  static navigate(BuildContext context, String url, sessionId) async {
    if (url.contains('mobile-sdk-redirect')) {
      await NetworkUtils.fetchPaymentTransaction(
        sessionId,
        methodType: '2',
        context: context,
        apikey: NetworkUtils.token,
        openScreen: () {
          var redirectResponse = NetworkUtils.fetchPaymentTransactions;
          Navigator.of(context).pop();
          if (redirectResponse.state == 'paid') {
            NetworkUtils.paymentDelegates!.successCallback(
                jsonEncode(redirectResponse.responseConfig!.toJson()));
            Navigator.of(context).pop();
            Navigator.popUntil(
                context, (Route<dynamic> predicate) => predicate.isFirst);
            //Dialogs().showSuccessDialog(context, currencyCode);
          } else {
            NetworkUtils.paymentDelegates!.cancelCallback(
                jsonEncode(redirectResponse.responseConfig!.toJson()));
            Navigator.of(context).pop();
            Navigator.popUntil(
                context, (Route<dynamic> predicate) => predicate.isFirst);
            //Dialogs().showFailDialog(context);
          }
        },
      );
    }
  }
}
