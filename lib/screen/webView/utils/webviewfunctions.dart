import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ottu/Networkutils/networkUtils.dart';
import 'package:ottu/consts/consts.dart';

///webview controllers
class WebViewFunctions {
  static navigate(BuildContext context, String url, sessionId) async {
    if (url.contains('mobile-sdk-redirect')) {
      await NetworkUtils.fetchPaymentTransaction(
        sessionId,
        methodType: '2',
        context: context,
        openScreen: () {
          var redirectResponse = NetworkUtils.fetchPaymentTransactions;
          Navigator.of(context).pop();
          if (redirectResponse.state == 'paid') {
            var data = {
              "status": "Success",
              "message": "Payment operation has Success.",
              "session_id": redirectResponse.sessionId,
              "order_no": "",
              "operation": "",
              "reference_number": '',
              "redirect_url": "",
              "merchant_id": merchantid,
            };
            NetworkUtils.paymentDelegates!.successCallback(data.toString());
            Navigator.of(context).pop();
            Navigator.popUntil(
                context, (Route<dynamic> predicate) => predicate.isFirst);
            //Dialogs().showSuccessDialog(context, currencyCode);
          } else {
            var data = {
              "status": "Fail",
              "message": "Payment operation has Failed.",
              "session_id": redirectResponse.sessionId,
              "order_no": "",
              "operation": "",
              "reference_number": '',
              "redirect_url": "",
              "merchant_id": merchantid,
            };
            NetworkUtils.paymentDelegates!.cancelCallback(data.toString());
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
