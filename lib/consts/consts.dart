import 'package:flutter/cupertino.dart';
import 'package:ottu/screen/payment_details_screen.dart';

// ignore: constant_identifier_names
String merchantid = '';
String BASEURL = 'https://$merchantid/b/';

String sessionId = '';
Locale currentLocale = const Locale('en');
String amount = '';
String status = '';
String currencyCode = '';
String? customerId = '';
bool isLoading = false;
bool isEnabled = true;
// bool keyboard = false;
final paymentScreenKey = GlobalKey<PaymentDetailsScreenState>();

const String METHOD_TYPE_OTTU = '1';
const String METHOD_TYPE_WEB = '2';
const String METHOD_TYPE_STC = '3';
