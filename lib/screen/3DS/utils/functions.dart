import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ottu/Networkutils/networkUtils.dart';
import 'package:web_socket_channel/io.dart';
import '../../../consts/consts.dart';

///socketController
class WebViewWithSocketScreenFunction {
  static IOWebSocketChannel? _channel;
  static const JsonDecoder _decoder = JsonDecoder();

  static init(String socketUrl, referenceNumber, BuildContext context) {
    _channel = IOWebSocketChannel.connect(Uri.parse(socketUrl));
    var details = {
      "client_type": "sdk",
      "merchant_id": merchantid,
      "reference_number": referenceNumber,
    };
    _channel!.sink.add(jsonEncode(details));
    _channel!.stream.listen((response) {
      log(response.toString());
      navigate(response, context);
    });
  }

  static dispose() {
    _channel!.sink.close();
  }

  static navigate(String response, BuildContext context) {
    var res = _decoder.convert(response);

    if (res['status'] == 'canceled') {
      NetworkUtils.paymentDelegates!.cancelCallback(jsonEncode(res));
      Navigator.of(context).pop();
      Navigator.popUntil(
          context, (Route<dynamic> predicate) => predicate.isFirst);
      // Dialogs().showFailDialog(context);
    } else if (res['status'] == 'success') {
      NetworkUtils.paymentDelegates!.successCallback(jsonEncode(res));
      Navigator.of(context).pop();
      Navigator.popUntil(
          context, (Route<dynamic> predicate) => predicate.isFirst);
      // Dialogs().showSuccessDialog(context, currencyCode);
    }
  }
}
