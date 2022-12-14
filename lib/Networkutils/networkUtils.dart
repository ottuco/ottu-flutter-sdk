// ignore_for_file: file_names
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
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

import '../security/Encryption.dart';

///API Handeling
class NetworkUtils {
  static String token = '';

  static const JsonDecoder _decoder = JsonDecoder();

  static PaymentDelegate? paymentDelegates;

  static FetchPaymentTransaction fetchPaymentTransactions =
      FetchPaymentTransaction();
  static Future fetchPaymentTransaction(
    String sessionId, {
    required Function openScreen,
    BuildContext? context,
    PaymentDelegate? paymentDelegate,
    String sdkLanguage = 'en',
    String methodType = '1',
    String apikey = '',
    String merchantId = '',
  }) async {
    token = apikey;
    merchantid = merchantId;
    if (!Platform.isIOS) {
      bool isSecure = await NotSecureDevice().checkSecureDevice(context!);
      if (isSecure) return;
    }
    if (methodType == '1') paymentDelegates = paymentDelegate;
    if (sdkLanguage == 'en') {
      currentLocale = const Locale('en');
    } else if (sdkLanguage.isEmpty) {
      currentLocale = const Locale('en');
    } else {
      currentLocale = const Locale('ar');
    }
    return await http.get(
      Uri.parse(
        '${BASEURL}checkout/api/sdk/v1/pymt-txn/submit/$sessionId?enableCHD=true',
      ),
      headers: {
        'Authorization': 'Api-Key $token',
        'Content-Type': 'application/json',
      },
    ).then((http.Response response) async {
      var res = _decoder.convert(response.body);
      var statusCode = response.statusCode;
      try {
        if (statusCode == 200) {
          if (!Platform.isIOS) {
            await FlutterWindowManager.addFlags(
                FlutterWindowManager.FLAG_SECURE);
          }
          fetchPaymentTransactions = FetchPaymentTransaction.fromJson(res);
          sessionId = fetchPaymentTransactions.sessionId.toString();
          if (methodType == '1') {
            Navigator.of(context!).push(
              MaterialPageRoute(
                builder: (ctx) => PaymentScreen(
                  fetchPaymentTransactions: fetchPaymentTransactions,
                  key: paymentScreenKey,
                ),
              ),
            );
          } else {
            openScreen();
          }
        } else {
          log(res.toString());
        }
      } catch (e) {
        throw Exception(e);
      }
    });
  }

  Future deleteCard(
      String deleteurl, Function deleteCard, BuildContext context) async {
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
      var publicKey = publicKeyResponse.statusCode == 200
          ? jsonDecode(publicKeyResponse.body)['public_key']
          : '';
      var secretid = publicKeyResponse.statusCode == 200
          ? jsonDecode(publicKeyResponse.body)['secret_id']
          : '';
      var details = {
        "merchant_id": merchantid,
        "session_id": sessionID,
        "payment_method": "card",
        "secret_id": secretid,
        "card": EncrypData().encrypt(
          json.encode({
            "name_on_card": nameoncard,
            "number": cardnumber,
            "expiry_year": expiryYear,
            "expiry_month": expiryMonth,
            "cvv": cvv,
            "save_card": savecard
          }),
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

  static Future createredirectURL(
      String redirecUrl, sessionId, code, BuildContext context) async {
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
      if (kDebugMode) {
        print(res);
      }
      if (res['status'] == 'success') {
        paymentDelegates!.beforeRedirect(res.toString());
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => WebViewScreen(
              webviewURL: res['redirect_url'],
              sessionId: fetchPaymentTransactions.sessionId.toString(),
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
      body: json.encode({
        "apple_url":
            "https://apple-pay-gateway.apple.com/paymentservices/paymentSession",
        "session_id": sessionId,
        "code": "apple-pay"
      }),
    )
        .then((value) async {
      var responeStatuscode = value.statusCode;
      if (responeStatuscode == 200) {
        var data = await ApplePay().pay(
            amount, merchantIdentifier, currencycode, countryCode, context);
        var res = json.decode(data);
        applePayPaymentUrl(
            paymentURL, context, currencycode, amount, res, merchantIdentifier);
      }
    });
  }

  static Future applePayPaymentUrl(
      String url,
      BuildContext context,
      String currencycode,
      String amount,
      dynamic paymentdata,
      String merchant_id) async {
    String tid = paymentdata['header']['transactionId'];
    return http
        .post(Uri.parse(url),
            headers: {
              'Authorization': 'Api-Key $token',
              'Content-Type': 'application/json',
            },
            body: json.encode({
              "session_id": sessionId,
              "code": "apple-pay",
              "currency_code": currencycode,
              "amount": amount,
              "apple_pay_payload": {
                "token": {
                  "token": {
                    "paymentData": paymentdata,
                    "paymentMethod": {
                      "displayName": merchant_id,
                      "network": "network",
                      "type": "apple-pay"
                    },
                    "transactionIdentifier": tid
                  }
                }
              }
            }))
        .then((value) async {
      var responeStatuscode = value.statusCode;
      if (responeStatuscode == 200) {
        // Dialogs().showProgressDialog(context);
        await NetworkUtils.fetchPaymentTransaction(
          sessionId,
          methodType: '2',
          context: context,
          apikey: NetworkUtils.token,
          openScreen: () {
            var redirectResponse = NetworkUtils.fetchPaymentTransactions;
            if (redirectResponse.state == 'paid') {
              NetworkUtils.paymentDelegates!.successCallback(
                  jsonEncode(redirectResponse.responseConfig!.toJson()));
              Navigator.of(context).pop();
            } else {
              NetworkUtils.paymentDelegates!.cancelCallback(
                  jsonEncode(redirectResponse.responseConfig!.toJson()));
              Navigator.of(context).pop();
            }
          },
        );
      } else {
        ShowToast().showToast('Try Again!');
      }
    });
  }
}
