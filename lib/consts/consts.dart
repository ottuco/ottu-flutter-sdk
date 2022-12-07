import 'package:flutter/cupertino.dart';

import '../screen/paymentScreen.dart';

// ignore: constant_identifier_names
String merchantid = '';
String BASEURL = 'https://$merchantid/b/';

String sessionId = '';
Locale currentLocale = const Locale('en');
String amount = '';
String status = '';
String currencyCode = '';
String customerId = '';
bool isLoading = false;
bool isEnabled = true;
// bool keyboard = false;
final paymentScreenKey = GlobalKey<PaymentDetailsScreenState>();
