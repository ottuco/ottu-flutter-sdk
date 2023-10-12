// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ottu/consts/colors.dart';
import 'package:ottu/consts/consts.dart';
import 'package:ottu/models/fetchpaymenttransaction.dart' as c;
import 'package:ottu/screen/payment_details_screen.dart';
import '../generated/l10n.dart';

///Main screen for sdk
class PaymentScreen extends StatelessWidget {
  final c.Payment? payment;
  final String? type;
  const PaymentScreen({Key? key, this.payment, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: primaryColor),
      ),
      home: PaymentDetailsScreen(
        payment: payment,
        context: context,
      ),
      locale: currentLocale,
      localizationsDelegates: const [
        //localedelegates
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      //sdklocale
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}
