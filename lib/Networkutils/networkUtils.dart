// ignore_for_file: file_names
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:ottu/applePay/applePay.dart';
import 'package:ottu/consts/consts.dart';
import 'package:ottu/models/3DSResponse.dart';
import 'package:ottu/models/fetchpaymenttransaction.dart';
import 'package:ottu/paymentDelegate/paymentDelegate.dart';
import 'package:ottu/screen/3DS/WebViewWithSocketScreen.dart';
import 'package:ottu/screen/paymentScreen.dart';
import 'package:ottu/screen/webView/webViewScreen.dart';
import 'package:ottu/security/jailBreakDetection.dart';
import 'package:ottu/widget/Toast.dart';
import 'package:ottu/screen/mobile_popup_screen.dart';

import '../security/Encryption.dart';

///API Handeling
class NetworkUtils {
  static String token = '';

  static const JsonDecoder _decoder = JsonDecoder();

  static PaymentDelegate? paymentDelegates;

  static Payment payment = Payment();

  static Future<http.Response> getPaymentDetails(
    String sessionId, {
    required Function openScreen,
    BuildContext? context,
    PaymentDelegate? paymentDelegate,
    String sdkLanguage = 'en',
    String methodType = METHOD_TYPE_OTTU,
    String apikey = '',
    String merchantId = '',
  }) async {
    if (context == null) {
      throw Exception("Context cannot be null");
    }

    token = apikey;
    merchantid = merchantId;

    if (!Platform.isIOS) {
      bool isSecure = await NotSecureDevice().checkSecureDevice(context);
      if (isSecure) return http.Response('', 403);
    }

    if (methodType != METHOD_TYPE_WEB) paymentDelegates = paymentDelegate;

    if (sdkLanguage == 'en') {
      currentLocale = const Locale('en');
    } else if (sdkLanguage.isEmpty) {
      currentLocale = const Locale('en');
    } else {
      currentLocale = const Locale('ar');
    }

    var url = '${BASEURL}checkout/api/sdk/v1/pymt-txn/submit/$sessionId?enableCHD=true';
    var headers = {
      'Authorization': 'Api-Key $token',
      'Content-Type': 'application/json',
    };

    try {
      var response = await http.get(Uri.parse(url), headers: headers);
      var res = _decoder.convert(response.body);
      var statusCode = response.statusCode;

      debugPrint('\n\n**************** Request ***********\n - URL: $url, \n Headers: $headers');
      debugPrint('\n\n********** Response *****************\n - Status code: $statusCode, \n Body: $res');

      if (statusCode == 200) {
        if (!Platform.isIOS) {
          await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
        }

        payment = Payment.fromJson(res);
        sessionId = payment.sessionId.toString();

        if (methodType == METHOD_TYPE_OTTU) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => PaymentScreen(
                payment: payment,
                key: paymentScreenKey,
              ),
            ),
          );
        } else if(methodType == METHOD_TYPE_STC) {
          PaymentMethod? stcPaymentMethod = payment.paymentMethods?.firstWhere((element) => element.flow == "stc_pay");
          if(stcPaymentMethod != null) showMobileOTPPopup(context, stcPaymentMethod);
        } else {
          openScreen();
        }
      } else {
        log(res.toString());
      }

      return response; // return the response
    } catch (e) {
      throw Exception(e);
    }
  }

  Future deleteCard(String deleteurl, Function deleteCard, BuildContext context) async {
    return await http.delete(
      Uri.parse(deleteurl),
      headers: {
        'Authorization': 'Api-Key $token',
      },
    ).then((http.Response response) {
      var statusCode = response.statusCode;
      if (statusCode == 204) {
        deleteCard();
      } else {
        ShowToast().showToast('Try Again!');
      }
    });
  }

  static ThreeDsResponse threeDSResponse = ThreeDsResponse();
  static Future pay(
    String sessionID,
    String submitURL,
    BuildContext context,
    String type, {
    String? publickeyurl,
    String savedcardcvv = '',
    String? nameoncard,
    String? cardnumber,
    bool? paywithcvv,
    String? expiryYear,
    String? expiryMonth,
    int? cvv,
    bool? savecard = false,
    String? cardToken,
  }) async {
    var paymentDetails = '';
    if (type == 'paywithsavedcard') {
      var details = {};
      if (paywithcvv!) {
        details = {
          "merchant_id": merchantid,
          "session_id": sessionID,
          "payment_method": "token",
          "token": cardToken,
          "cvv": savedcardcvv,
        };
      } else {
        details = {
          "merchant_id": merchantid,
          "session_id": sessionID,
          "payment_method": "token",
          "token": cardToken,
        };
      }
      paymentDetails = jsonEncode(details);
    } else {
      var publicKeyResponse = await getPublicKey(publickeyurl.toString());
      var publicKey = publicKeyResponse.statusCode == 200 ? jsonDecode(publicKeyResponse.body)['public_key'] : '';
      var secretid = publicKeyResponse.statusCode == 200 ? jsonDecode(publicKeyResponse.body)['secret_id'] : '';
      var details = {
        "merchant_id": merchantid,
        "session_id": sessionID,
        "payment_method": "card",
        "secret_id": secretid,
        "card": EncrypData().encrypt(
          json.encode({"name_on_card": nameoncard, "number": cardnumber, "expiry_year": expiryYear, "expiry_month": expiryMonth, "cvv": cvv, "save_card": savecard}),
          publicKey,
        ),
      };
      paymentDetails = jsonEncode(details);
    }
    return await http
        .post(
      Uri.parse(submitURL),
      headers: {
        'Authorization': 'Api-Key $token',
        'Content-Type': 'application/json',
      },
      body: paymentDetails,
    )
        .then((http.Response response) async {
      var res = _decoder.convert(response.body);
      var statusCode = response.statusCode;
      var status = res['status'];

      if (statusCode == 200) {
        if (status == 'success') {
          status = status;
          paymentDelegates!.successCallback(res.toString());
          Navigator.of(context).pop();
        } else if (status == 'canceled') {
          status = status;
          paymentDelegates!.cancelCallback(res.toString());
          Navigator.of(context).pop();
        } else if (status == '3DS') {
          threeDSResponse = ThreeDsResponse.fromJson(res);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => WebViewWithSocketScreen(
                threeDsResponse: threeDSResponse,
              ),
            ),
          );
        } else {
          ShowToast().showToast('Try Again!');
        }
      }
    });
  }

  static Future<http.Response> getPublicKey(String url) async {
    return await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Api-Key $token',
      },
    );
  }

  static Future openWebViewForRedirect(String redirecUrl, sessionId, code, BuildContext context) async {
    if (code == 'ottu_pg_kwd_tkn') {
      redirecUrl += redirecUrl.contains('?') ? '&channel=mobile_sdk' : '?channel=mobile_sdk';
    }
    var details = {
      "pg_code": code,
      "channel": "mobile_sdk",
    };
    var urlDetails = json.encode(details);

    return await http.post(
      Uri.parse(redirecUrl),
      body: urlDetails,
      headers: {
        'Authorization': 'Api-Key $token',
        'Content-Type': 'application/json',
      },
    ).then((http.Response response) {
      var res = {};
      try {
        res = _decoder.convert(response.body);
      } catch (e) {
        log(e.toString());
      }
      if (kDebugMode) {}
      if (res['status'] == 'success') {
        paymentDelegates!.beforeRedirect(res.toString());
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => WebViewScreen(
              webviewURL: res['redirect_url'],
              sessionId: payment.sessionId.toString(),
            ),
          ),
        );
      } else {
        ShowToast().showToast(res['message']);
      }
    });
  }

  static Future applePayvalidationUrl(
    String url,
    String paymentURL,
    String amount,
    BuildContext context,
    String currencycode,
    String countryCode,
    String merchantIdentifier,
  ) async {
    return http
        .post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Api-Key $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({"apple_url": "https://apple-pay-gateway.apple.com/paymentservices/paymentSession", "session_id": sessionId, "code": "apple-pay"}),
    )
        .then((value) async {
      var responeStatuscode = value.statusCode;
      if (responeStatuscode == 200) {
        var data = await ApplePay().pay(amount, merchantIdentifier, currencycode, countryCode, context);
        var res = json.decode(data);
        applePayPaymentUrl(paymentURL, context, currencycode, amount, res, merchantIdentifier);
      }
    });
  }

  static Future applePayPaymentUrl(String url, BuildContext context, String currencyCode, String amount, dynamic paymentData, String merchantId) async {
    final applePayPayload = _buildApplePayPayload(paymentData, merchantId);
    await _postPaymentRequest(url, applePayPayload).then((response) async {
      var callbackPayload = json.decode(response.body);
      if (callbackPayload != null && callbackPayload.containsKey("callback_payload")) {
        final redirectUrl = callbackPayload["callback_payload"];
        if (response.statusCode == 200) {
          status = status;
            paymentDelegates!.successCallback(jsonEncode(redirectUrl));
            Navigator.of(context).pop();
        }else if (response.statusCode == 400){  
          paymentDelegates!.errorCallback(jsonEncode(redirectUrl));
          Navigator.of(context).pop();
        }else{
            paymentDelegates!.errorCallback(jsonEncode(redirectUrl));
            Navigator.of(context).pop();
        }
      }else{
        paymentDelegates!.errorCallback(jsonEncode(callbackPayload));
            Navigator.of(context).pop();
      }
    });
    
  }

  static Map<String, dynamic> _buildApplePayPayload(dynamic paymentData, String merchantId) {
    final tid = paymentData['header']['transactionId'];
    return {
      "session_id": sessionId,
      "code": "apple-pay",
      "currency_code": currencyCode,
      "amount": amount,
      "apple_pay_payload": {
        "token": {
          "token": {
            "paymentData": paymentData,
            "paymentMethod": {"displayName": merchantId, "network": "network", "type": "apple-pay"},
            "transactionIdentifier": tid
          }
        }
      }
    };
  }

  static Future<Response> _postPaymentRequest(String url, Map<String, dynamic> applePayPayload) {
    return http
        .post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Api-Key $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(applePayPayload),
    )
        .then((response) {
      if (response.statusCode == 200) {
      } else {
        print('Request failed with response: ${response.body}');
      }
      return response;
    }).catchError((error) {
      throw error;
    });
  }

/*
  static Future<void> _fetchPaymentTransaction(BuildContext context) async {
    final redirectResponse = await NetworkUtils.getPaymentDetails(
      sessionId,
      openScreen: (e) {},
      context: context,
      paymentDelegate: paymentDelegates,
      sdkLanguage: 'en',
      apikey: token,
      merchantId: merchantid,
    );

    final jsonResponse = json.decode(redirectResponse.body);
    final response = jsonResponse['response'].toString();
    final status = jsonResponse['response']['status'].toString();

    ShowToast().showToast(response);

    if (status == 'paid') {
      NetworkUtils.paymentDelegates!.successCallback(response);
    } else {
      NetworkUtils.paymentDelegates!.cancelCallback(response);
    }

    try {
      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      log('An error occurred while popping the navigation stack: $e');
    }
  }
*/
}
