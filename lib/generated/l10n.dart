// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Payment Details`
  String get PaymentDetails {
    return Intl.message(
      'Payment Details',
      name: 'PaymentDetails',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get TotalBill {
    return Intl.message(
      'Total',
      name: 'TotalBill',
      desc: '',
      args: [],
    );
  }

  /// `Debit / Credit Card`
  String get Debit_CreditCard {
    return Intl.message(
      'Debit / Credit Card',
      name: 'Debit_CreditCard',
      desc: '',
      args: [],
    );
  }

  /// `Name On Card`
  String get NameOnCard {
    return Intl.message(
      'Name On Card',
      name: 'NameOnCard',
      desc: '',
      args: [],
    );
  }

  /// `Card Number`
  String get CardNumber {
    return Intl.message(
      'Card Number',
      name: 'CardNumber',
      desc: '',
      args: [],
    );
  }

  /// `Click To Save Your Card`
  String get ClickToSaveYourCard {
    return Intl.message(
      'Click To Save Your Card',
      name: 'ClickToSaveYourCard',
      desc: '',
      args: [],
    );
  }

  /// `You have incorrectly entered your expiration date`
  String get Youhaveincorrectlyenteredyourexpirationdate {
    return Intl.message(
      'You have incorrectly entered your expiration date',
      name: 'Youhaveincorrectlyenteredyourexpirationdate',
      desc: '',
      args: [],
    );
  }

  /// `Saved Cards`
  String get SavedCards {
    return Intl.message(
      'Saved Cards',
      name: 'SavedCards',
      desc: '',
      args: [],
    );
  }

  /// `List of all cards saved`
  String get Listofallcardssaved {
    return Intl.message(
      'List of all cards saved',
      name: 'Listofallcardssaved',
      desc: '',
      args: [],
    );
  }

  /// `Expires on`
  String get Expireson {
    return Intl.message(
      'Expires on',
      name: 'Expireson',
      desc: '',
      args: [],
    );
  }

  /// `Expired on`
  String get Expiredon {
    return Intl.message(
      'Expired on',
      name: 'Expiredon',
      desc: '',
      args: [],
    );
  }

  /// `Click Confirm if you don't want this payment method to be displayed in your payment options`
  String
      get ClickConfirmifyoudontwantthispaymentmethodtobedisplayedinyourpaymentoptions {
    return Intl.message(
      'Click Confirm if you don\'t want this payment method to be displayed in your payment options',
      name:
          'ClickConfirmifyoudontwantthispaymentmethodtobedisplayedinyourpaymentoptions',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get Confirm {
    return Intl.message(
      'Confirm',
      name: 'Confirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get Cancel {
    return Intl.message(
      'Cancel',
      name: 'Cancel',
      desc: '',
      args: [],
    );
  }

  /// `Pay`
  String get pay {
    return Intl.message(
      'Pay',
      name: 'pay',
      desc: '',
      args: [],
    );
  }

  /// `Delete Card?`
  String get DeleteCard {
    return Intl.message(
      'Delete Card?',
      name: 'DeleteCard',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure, you want to delete this card?`
  String get Areyousureyouwanttodeletethiscard {
    return Intl.message(
      'Are you sure, you want to delete this card?',
      name: 'Areyousureyouwanttodeletethiscard',
      desc: '',
      args: [],
    );
  }

  /// `Payment Failed`
  String get PaymentFailed {
    return Intl.message(
      'Payment Failed',
      name: 'PaymentFailed',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get Ok {
    return Intl.message(
      'Ok',
      name: 'Ok',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get Remove {
    return Intl.message(
      'Remove',
      name: 'Remove',
      desc: '',
      args: [],
    );
  }

  /// `Expiry`
  String get Expiry {
    return Intl.message(
      'Expiry',
      name: 'Expiry',
      desc: '',
      args: [],
    );
  }

  /// `CVV`
  String get CCV {
    return Intl.message(
      'CVV',
      name: 'CCV',
      desc: '',
      args: [],
    );
  }

  /// `MM/YY`
  String get MM_YY {
    return Intl.message(
      'MM/YY',
      name: 'MM_YY',
      desc: '',
      args: [],
    );
  }

  /// `Pay Now`
  String get PayNow {
    return Intl.message(
      'Pay Now',
      name: 'PayNow',
      desc: '',
      args: [],
    );
  }

  /// `Payment Methods`
  String get PaymentMethods {
    return Intl.message(
      'Payment Methods',
      name: 'PaymentMethods',
      desc: '',
      args: [],
    );
  }

  /// `List of all gateways we support`
  String get Listofallgatewayswesupport {
    return Intl.message(
      'List of all gateways we support',
      name: 'Listofallgatewayswesupport',
      desc: '',
      args: [],
    );
  }

  /// `Card Validator Value is invalid`
  String get CardValidatorValueisinvalid {
    return Intl.message(
      'Card Validator Value is invalid',
      name: 'CardValidatorValueisinvalid',
      desc: '',
      args: [],
    );
  }

  /// `Expiry month is invalid`
  String get Expirymonthisinvalid {
    return Intl.message(
      'Expiry month is invalid',
      name: 'Expirymonthisinvalid',
      desc: '',
      args: [],
    );
  }

  /// `Card has expired`
  String get Cardhasexpired {
    return Intl.message(
      'Card has expired',
      name: 'Cardhasexpired',
      desc: '',
      args: [],
    );
  }

  /// `Expiry year is invalid`
  String get Expiryyearisinvalid {
    return Intl.message(
      'Expiry year is invalid',
      name: 'Expiryyearisinvalid',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get Thisfieldisrequired {
    return Intl.message(
      'This field is required',
      name: 'Thisfieldisrequired',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations your transaction is completed successfully`
  String get Congratulationsyourtransferwascompletedsuccessfully {
    return Intl.message(
      'Congratulations your transaction is completed successfully',
      name: 'Congratulationsyourtransferwascompletedsuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `is paid`
  String get ispaid {
    return Intl.message(
      'is paid',
      name: 'ispaid',
      desc: '',
      args: [],
    );
  }

  /// `sorry! your payment is failed please check your card details.`
  String get sorryyourpaymentisfailedpleasecheckyourcarddetails {
    return Intl.message(
      'sorry! your payment is failed please check your card details.',
      name: 'sorryyourpaymentisfailedpleasecheckyourcarddetails',
      desc: '',
      args: [],
    );
  }

  /// `Fees`
  String get fees {
    return Intl.message(
      'Fees',
      name: 'fees',
      desc: '',
      args: [],
    );
  }

  /// `Subtotal`
  String get Subtotal {
    return Intl.message(
      'Subtotal',
      name: 'Subtotal',
      desc: '',
      args: [],
    );
  }

  /// `Or Pay With Card`
  String get OrPayWithCard {
    return Intl.message(
      'Or Pay With Card',
      name: 'OrPayWithCard',
      desc: '',
      args: [],
    );
  }

  /// `With saved card you can skip entering card details in your next transaction`
  String get Withsavedcardyoucanskipenteringcarddetailsinyournexttransaction {
    return Intl.message(
      'With saved card you can skip entering card details in your next transaction',
      name: 'Withsavedcardyoucanskipenteringcarddetailsinyournexttransaction',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
