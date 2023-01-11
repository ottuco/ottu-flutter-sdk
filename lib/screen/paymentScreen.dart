// ignore_for_file: file_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ottu/Networkutils/networkUtils.dart';
import 'package:ottu/consts/colors.dart';
import 'package:ottu/consts/consts.dart';
import 'package:ottu/models/fetchpaymenttransaction.dart' as c;
import 'package:ottu/widget/shimmer.dart';
import '../applePay/applePay.dart';
import '../cardValidators/payment_card.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";
import '../consts/imagePath.dart';
import '../functions/pay.dart';
import '../generated/l10n.dart';
import '../widget/cardTile.dart';
import '../widget/dialogs.dart';
import '../widget/savedCard.dart';

///Main screen for sdk
class PaymentScreen extends StatelessWidget {
  final c.FetchPaymentTransaction? fetchPaymentTransactions;
  final String? type;
  const PaymentScreen({Key? key, this.fetchPaymentTransactions, this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: primaryColor),
      ),
      home: PaymentDetailsScreen(
        fetchPaymentTransactions: fetchPaymentTransactions,
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

class PaymentDetailsScreen extends StatefulWidget {
  final c.FetchPaymentTransaction? fetchPaymentTransactions;
  final String? type;
  final BuildContext? context;
  const PaymentDetailsScreen({
    Key? key,
    this.fetchPaymentTransactions,
    this.type,
    this.context,
  }) : super(key: key);

  @override
  State<PaymentDetailsScreen> createState() => PaymentDetailsScreenState();
}

final GlobalKey<State> keyLoader = GlobalKey<State>();
final paymentCard = PaymentCard();

String submitURL = '';
bool ischecked = false;
c.Card paywithSavedCard = c.Card();
c.PaymentMethod paywithRedirectFlow = c.PaymentMethod();
var payType = '';

class PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  //controllers
  final cvvController = TextEditingController();
  final cardOnNameController = TextEditingController();
  final dateController = TextEditingController();
  final savedcardcvvControllers = <TextEditingController>[
    TextEditingController()
  ];
  final TextEditingController numberController =
      TextEditingController(text: '');
  final scaffoldState = GlobalKey<ScaffoldState>();
  bool isEnable = true;
  String fees = '';
  var cvvString = '';
  String feesCurrencyCode = '';
  String total = '';
  bool cvvrequired = false;
  bool ignoreTouch = false;
  int savedcvvindex = 0;

  c.FetchPaymentTransaction fetchPaymentTransaction =
      c.FetchPaymentTransaction();
  //handeling card image
  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    if (mounted) {
      setState(() {
        paymentCard.type = cardType;
      });
    }
  }

  onLoadComplete() async {
    Future.delayed(
        const Duration(
          seconds: 2,
        ), () {
      setState(() {
        isEnable = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    //sdk initialization
    onLoadComplete();
    paymentCard.type = CardType.Others;
    for (var element in widget.fetchPaymentTransactions!.paymentMethods!) {
      if (element.flow == 'card') {
        numberController.addListener(_getCardTypeFrmNumber);
        break;
      }
    }

    if (widget.type != '1') {
      setState(() {
        payType = '';
        fetchPaymentTransaction = widget.fetchPaymentTransactions!;
        customerId = widget.fetchPaymentTransactions!.customerId.toString();
        amount = widget.fetchPaymentTransactions!.amount.toString();
        sessionId = fetchPaymentTransaction.sessionId.toString();
        currencyCode = fetchPaymentTransaction.currencyCode.toString();
      });
    } else {
      setState(() {
        payType = '';
        fetchPaymentTransaction = NetworkUtils.fetchPaymentTransactions;
        customerId =
            NetworkUtils.fetchPaymentTransactions.customerId.toString();
        amount = NetworkUtils.fetchPaymentTransactions.amount.toString();
        sessionId = NetworkUtils.fetchPaymentTransactions.sessionId.toString();
        currencyCode = fetchPaymentTransaction.currencyCode.toString();
      });
    }
    generateControllers();
  }

  setPayButtonEnabled(String cvv) {
    setState(() {
      cvvString = cvv;
    });
  }

  void generateControllers() {
    if (fetchPaymentTransaction.cards!.isNotEmpty) {
      savedcardcvvControllers.clear();
      List.generate(fetchPaymentTransaction.cards!.length, (index) {
        var con = TextEditingController();
        savedcardcvvControllers.add(con);
      });
    }
  }

  @override
  void dispose() {
    /// to dispose controllers
    if (mounted) {
      cvvController.clear();
      cardOnNameController.clear();
      dateController.clear();
      numberController.removeListener(() {});
      numberController.clear();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: canvasColor,
        key: scaffoldState,
        body: ScreenUtilInit(builder: (context, child) {
          return Stack(
            children: [
              ListView(
                children: [
                  Form(
                    key: formKey,
                    child: IgnorePointer(
                      ignoring: ignoreTouch,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),

                          /// shimmer Animation
                          if (isEnable)
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: const ShimmerWidget.rect(
                                  height: 100.0,
                                ),
                              ),
                            ),

                          /// ---- End Shimmer Animation

                          /// Total amount
                          if (!isEnable)
                            Container(
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(16),
                                border:
                                    Border.all(color: shadowColor, width: 3),
                              ),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (total.isNotEmpty &&
                                        double.parse(fees) > 0)
                                      Row(
                                        children: [
                                          Text(
                                            S.of(context).Subtotal,
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              color: secondaryColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const Spacer(),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: fetchPaymentTransaction
                                                      .amount
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 17.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      ' ${fetchPaymentTransaction.currencyCode}',
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                    color: primaryColor,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (total.isNotEmpty &&
                                        double.parse(fees) > 0)
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    if (fees.isNotEmpty &&
                                        double.parse(fees) > 0)
                                      Row(
                                        children: [
                                          Text(
                                            S.of(context).fees,
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              color: secondaryColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const Spacer(),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: fees.toString(),
                                                  style: TextStyle(
                                                    fontSize: 17.sp,
                                                    color: primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: ' $feesCurrencyCode',
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                    color: primaryColor,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (fees.isNotEmpty &&
                                        double.parse(fees) > 0)
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    if (fees.isNotEmpty &&
                                        double.parse(fees) > 0)
                                      const Divider(
                                        color: dividerColor,
                                      ),
                                    Row(
                                      children: [
                                        Text(
                                          S.of(context).TotalBill,
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            color: secondaryColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const Spacer(),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: amount.toString(),
                                                style: TextStyle(
                                                  fontSize: 17.sp,
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' $feesCurrencyCode',
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  color: primaryColor,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: dividerColor,
                                    ),

                                    /// ---- End Total Amount

                                    //Apple pay
                                    if (Platform.isIOS &&
                                        fetchPaymentTransaction
                                            .applePayAvailable!)
                                      const SizedBox(
                                        height: 10,
                                      ),

                                    if (Platform.isIOS &&
                                        fetchPaymentTransaction
                                            .applePayAvailable!)
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: blackColor,
                                          shape: const StadiumBorder(),
                                        ),
                                        onPressed: () {
                                          ApplePay().paywithApple(
                                            fetchPaymentTransaction
                                                .applePayConfig!.validationUrl
                                                .toString(),
                                            widget.context!,
                                            fetchPaymentTransaction
                                                .applePayConfig!.currencyCode!,
                                            fetchPaymentTransaction
                                                .applePayConfig!.countryCode!,
                                            fetchPaymentTransaction
                                                .applePayConfig!.amount!,
                                            fetchPaymentTransaction
                                                .applePayConfig!.shopName!,
                                            fetchPaymentTransaction
                                                .applePayConfig!.paymentUrl
                                                .toString(),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(11.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                '${imagePath}apple_logo.png',
                                                package: 'ottu',
                                                width: 20,
                                              ),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                              Text(
                                                S.of(context).pay,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    if (Platform.isIOS &&
                                        fetchPaymentTransaction
                                            .applePayAvailable! &&
                                        fetchPaymentTransaction
                                            .cards!.isNotEmpty)
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    if (Platform.isIOS &&
                                        fetchPaymentTransaction
                                            .applePayAvailable! &&
                                        fetchPaymentTransaction
                                            .cards!.isNotEmpty)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Flexible(
                                            child: Divider(
                                              color: dividerColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: Text(
                                              S.of(context).OrPayWithCard,
                                              style: const TextStyle(
                                                color: secondaryGreyColor,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                          const Flexible(
                                            child: Divider(
                                              color: dividerColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (Platform.isIOS &&
                                        fetchPaymentTransaction
                                            .applePayAvailable! &&
                                        fetchPaymentTransaction
                                            .cards!.isNotEmpty)
                                      const SizedBox(
                                        height: 14,
                                      ),

                                    ///---- End Apple pay

                                    ///Saved Card
                                    if (fetchPaymentTransaction
                                        .cards!.isNotEmpty)
                                      Text(
                                        S.of(context).SavedCards,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                    SizedBox(
                                      height: 5.sp,
                                    ),
                                    if (fetchPaymentTransaction
                                        .cards!.isNotEmpty)
                                      Text(
                                        S.of(context).Listofallcardssaved,
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          color: secondaryColor,
                                        ),
                                      ),
                                    if (fetchPaymentTransaction
                                        .cards!.isNotEmpty)
                                      const SizedBox(
                                        height: 7,
                                      ),
                                    if (fetchPaymentTransaction
                                        .cards!.isNotEmpty)
                                      ListView.builder(
                                        key: const ValueKey('savedcards'),
                                        padding: EdgeInsets.zero,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: fetchPaymentTransaction
                                            .cards!.length,
                                        shrinkWrap: true,
                                        itemBuilder: (ctx, i) {
                                          return InkWell(
                                            onTap: () {
                                              if (!fetchPaymentTransaction
                                                  .cards![i].isSelected) {
                                                for (var element
                                                    in fetchPaymentTransaction
                                                        .cards!) {
                                                  setState(() {
                                                    element.isSelected = false;
                                                  });
                                                }
                                                for (var element
                                                    in fetchPaymentTransaction
                                                        .paymentMethods!) {
                                                  setState(() {
                                                    element.isRedirectSelected =
                                                        false;
                                                  });
                                                }
                                                for (var element
                                                    in fetchPaymentTransaction
                                                        .paymentMethods!) {
                                                  setState(() {
                                                    element.isSelected = false;
                                                  });
                                                }
                                              }
                                              setState(() {
                                                fetchPaymentTransaction
                                                    .cards![i]
                                                    .isSelected = true;
                                                // !fetchPaymentTransaction
                                                //     .cards![i].isSelected;
                                                if (fetchPaymentTransaction
                                                    .cards![i].isSelected) {
                                                  paywithSavedCard =
                                                      fetchPaymentTransaction
                                                          .cards![i];
                                                  payType = '';
                                                  savedcvvindex = i;
                                                  cvvrequired =
                                                      fetchPaymentTransaction
                                                          .cards![i]
                                                          .requiredCvv!;
                                                  for (var methods
                                                      in fetchPaymentTransaction
                                                          .paymentMethods!) {
                                                    if (methods.code ==
                                                        fetchPaymentTransaction
                                                            .cards![i].pgCode) {
                                                      setState(() {
                                                        fees = methods.fee
                                                            .toString();
                                                        feesCurrencyCode =
                                                            methods.currencyCode
                                                                .toString();
                                                        amount = methods.amount
                                                            .toString();
                                                        total =
                                                            fetchPaymentTransaction
                                                                .amount
                                                                .toString();
                                                      });
                                                    }
                                                  }
                                                }
                                                if (!fetchPaymentTransaction
                                                    .cards![i].isSelected) {
                                                  setState(() {
                                                    total = '';
                                                    feesCurrencyCode = '';
                                                    amount =
                                                        fetchPaymentTransaction
                                                            .amount
                                                            .toString();
                                                    fees = '';
                                                    payType = '';
                                                  });
                                                }
                                              });
                                            },
                                            child: SavedCard(
                                              cvvStatus: setPayButtonEnabled,
                                              cvvcontroller:
                                                  savedcardcvvControllers[i],
                                              paywithcvv:
                                                  fetchPaymentTransaction
                                                      .cards![i].requiredCvv!,
                                              isSelected:
                                                  fetchPaymentTransaction
                                                      .cards![i].isSelected,
                                              brand: fetchPaymentTransaction
                                                  .cards![i].brand
                                                  .toString(),
                                              expiryMonth:
                                                  fetchPaymentTransaction
                                                      .cards![i].expiryMonth
                                                      .toString(),
                                              expiryYear:
                                                  fetchPaymentTransaction
                                                      .cards![i].expiryYear
                                                      .toString(),
                                              onCardTap: () {
                                                Dialogs().showDialogs(
                                                  context,
                                                  () async {
                                                    NetworkUtils().deleteCard(
                                                      fetchPaymentTransaction
                                                          .cards![i].deleteUrl
                                                          .toString(),
                                                      () {
                                                        setState(() {
                                                          fetchPaymentTransaction
                                                              .cards!
                                                              .removeAt(i);
                                                        });
                                                      },
                                                      context,
                                                    );
                                                  },
                                                  '${fetchPaymentTransaction.cards![i].brand} ${fetchPaymentTransaction.cards![i].number}',
                                                );
                                              },
                                              number: fetchPaymentTransaction
                                                  .cards![i].number
                                                  .toString(),
                                            ),
                                          );
                                        },
                                      ),

                                    ///---- End Saved Card
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 20,
                          ),

                          ///Shimmer Effect
                          if (isEnable)
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: const ShimmerWidget.rect(
                                  height: 200.0,
                                ),
                              ),
                            ),

                          ///---- end shimmer effect
                          if (!isEnable)

                            /// Payment menthods
                            Container(
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(16),
                                border:
                                    Border.all(color: shadowColor, width: 3),
                              ),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).PaymentMethods,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.sp,
                                    ),
                                    Text(
                                      S.of(context).Listofallgatewayswesupport,
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: secondaryColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      key: const ValueKey('methods'),
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      itemCount: fetchPaymentTransaction
                                          .paymentMethods!.length,
                                      itemBuilder: (ctx, i) {
                                        return CardTile(
                                          fetchPaymentTransaction.cansavecard!,
                                          setPayButtonEnabled,
                                          () {
                                            if (fetchPaymentTransaction
                                                    .paymentMethods![i].flow ==
                                                'card') {
                                              if (!fetchPaymentTransaction
                                                  .paymentMethods![i]
                                                  .isSelected) {
                                                for (var singleTransaction
                                                    in fetchPaymentTransaction
                                                        .paymentMethods!) {
                                                  setState(() {
                                                    singleTransaction
                                                        .isSelected = false;
                                                  });
                                                }
                                                for (var element
                                                    in fetchPaymentTransaction
                                                        .paymentMethods!) {
                                                  setState(() {
                                                    element.isRedirectSelected =
                                                        false;
                                                  });
                                                }
                                                if (fetchPaymentTransaction
                                                        .cards !=
                                                    null) {
                                                  for (var element
                                                      in fetchPaymentTransaction
                                                          .cards!) {
                                                    setState(() {
                                                      element.isSelected =
                                                          false;
                                                    });
                                                  }
                                                }
                                              }
                                              setState(() {
                                                fetchPaymentTransaction
                                                    .paymentMethods![i]
                                                    .isSelected = true;
                                                // fetchPaymentTransaction
                                                //         .paymentMethods![i]
                                                //         .isSelected =
                                                //     !fetchPaymentTransaction
                                                //         .paymentMethods![i]
                                                //         .isSelected;
                                                if (fetchPaymentTransaction
                                                    .paymentMethods![i]
                                                    .isSelected) {
                                                  payType = '';
                                                  submitURL =
                                                      fetchPaymentTransaction
                                                          .paymentMethods![i]
                                                          .submitUrl
                                                          .toString();
                                                  fees = fetchPaymentTransaction
                                                      .paymentMethods![i].fee
                                                      .toString();
                                                  feesCurrencyCode =
                                                      fetchPaymentTransaction
                                                          .paymentMethods![i]
                                                          .currencyCode
                                                          .toString();
                                                  total =
                                                      fetchPaymentTransaction
                                                          .paymentMethods![i]
                                                          .amount
                                                          .toString();

                                                  amount =
                                                      fetchPaymentTransaction
                                                          .paymentMethods![i]
                                                          .amount
                                                          .toString();
                                                } else {
                                                  setState(() {
                                                    fees = '';
                                                    total = '';
                                                    feesCurrencyCode = '';
                                                    amount =
                                                        fetchPaymentTransaction
                                                            .amount
                                                            .toString();
                                                    payType = '';
                                                  });
                                                }
                                              });
                                            } else {
                                              if (!fetchPaymentTransaction
                                                  .paymentMethods![i]
                                                  .isSelected) {
                                                for (var singleTransaction
                                                    in fetchPaymentTransaction
                                                        .paymentMethods!) {
                                                  setState(() {
                                                    singleTransaction
                                                        .isSelected = false;
                                                  });
                                                }
                                                if (fetchPaymentTransaction
                                                        .cards !=
                                                    null) {
                                                  for (var element
                                                      in fetchPaymentTransaction
                                                          .cards!) {
                                                    setState(() {
                                                      element.isSelected =
                                                          false;
                                                    });
                                                  }
                                                }
                                              }
                                              if (!fetchPaymentTransaction
                                                  .paymentMethods![i]
                                                  .isRedirectSelected) {
                                                for (var element
                                                    in fetchPaymentTransaction
                                                        .paymentMethods!) {
                                                  setState(() {
                                                    element.isRedirectSelected =
                                                        false;
                                                  });
                                                }
                                              }
                                              setState(() {
                                                fetchPaymentTransaction
                                                    .paymentMethods![i]
                                                    .isRedirectSelected = true;
                                                // !fetchPaymentTransaction
                                                //     .paymentMethods![i]
                                                //     .isRedirectSelected;
                                                if (fetchPaymentTransaction
                                                    .paymentMethods![i]
                                                    .isRedirectSelected) {
                                                  fees = fetchPaymentTransaction
                                                      .paymentMethods![i].fee
                                                      .toString();
                                                  amount =
                                                      fetchPaymentTransaction
                                                          .paymentMethods![i]
                                                          .amount
                                                          .toString();
                                                  total =
                                                      fetchPaymentTransaction
                                                          .paymentMethods![i]
                                                          .amount
                                                          .toString();
                                                  feesCurrencyCode =
                                                      fetchPaymentTransaction
                                                          .paymentMethods![i]
                                                          .currencyCode
                                                          .toString();
                                                  paywithRedirectFlow =
                                                      fetchPaymentTransaction
                                                          .paymentMethods![i];
                                                  payType = 'redirectFlow';
                                                } else {
                                                  fees = '';
                                                  total = '';
                                                  feesCurrencyCode = '';
                                                  amount =
                                                      fetchPaymentTransaction
                                                          .amount
                                                          .toString();
                                                  payType = '';
                                                }
                                              });
                                            }
                                          },
                                          numberController,
                                          cvvController,
                                          cardOnNameController,
                                          dateController,
                                          // _numberFieldFocusNode,
                                          fetchPaymentTransaction
                                              .paymentMethods![i].icon
                                              .toString(),
                                          fetchPaymentTransaction
                                              .paymentMethods![i].name
                                              .toString(),
                                          fetchPaymentTransaction
                                              .paymentMethods![i].fee
                                              .toString(),
                                          fetchPaymentTransaction
                                              .paymentMethods![i].isSelected,
                                          fetchPaymentTransaction
                                              .paymentMethods![i].ischecked,
                                          () {
                                            setState(() {
                                              fetchPaymentTransaction
                                                      .paymentMethods![i]
                                                      .ischecked =
                                                  !fetchPaymentTransaction
                                                      .paymentMethods![i]
                                                      .ischecked;
                                              ischecked =
                                                  fetchPaymentTransaction
                                                      .paymentMethods![i]
                                                      .ischecked;
                                            });
                                          },
                                          fetchPaymentTransaction
                                              .paymentMethods![i]
                                              .isRedirectSelected,
                                          fetchPaymentTransaction.customerId
                                              .toString(),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          ///---- end payment method

                          const SizedBox(
                            height: 10,
                          ),

                          if (isEnable)
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: const ShimmerWidget.rect(
                                  height: 50.0,
                                ),
                              ),
                            ),
                          // if (cvvString.isNotEmpty || payType.isNotEmpty)
                          //   Container(
                          //     width: double.infinity,
                          //     padding: const EdgeInsets.symmetric(horizontal: 20),
                          //     child: ElevatedButton(
                          //       style: ElevatedButton.styleFrom(
                          //         primary: primaryColor,
                          //         shape: const StadiumBorder(),
                          //       ),
                          //       onPressed: null,
                          //       child: Padding(
                          //         padding: const EdgeInsets.all(14.0),
                          //         child: Text(
                          //           S.of(context).PayNow,
                          //           style: const TextStyle(
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: 17,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),

                          ///pay button
                          if (!isEnable)
                            Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ElevatedButton(
                                onPressed: cvvString.length != 3 &&
                                        payType.isEmpty
                                    ? null
                                    : () async {
                                        setState(() {
                                          ignoreTouch = true;
                                          isLoading = true;
                                          isEnabled = false;
                                        });
                                        try {
                                          await PayAmount.payAmount(
                                            publicKeyURL: widget
                                                .fetchPaymentTransactions!
                                                .publicKeyUrl
                                                .toString(),
                                            context: widget.context,
                                            savedcardcvvController:
                                                savedcardcvvControllers[
                                                    savedcvvindex],
                                            cvvrequired: cvvrequired,
                                            fetchPaymentTransaction:
                                                fetchPaymentTransaction,
                                            card: paywithSavedCard,
                                            cardOnNameController:
                                                cardOnNameController,
                                            cvvController: cvvController,
                                            dateController: dateController,
                                            numberController: numberController,
                                            paymentMethod: paywithRedirectFlow,
                                            closeCardView: () {
                                              if (payType == 'paywithcard') {
                                                for (var element
                                                    in fetchPaymentTransaction
                                                        .paymentMethods!) {
                                                  setState(() {
                                                    payType = '';
                                                    element.isSelected = false;
                                                  });
                                                }
                                              }
                                            },
                                          );
                                          setState(() {
                                            ignoreTouch = false;
                                            isLoading = false;
                                            isEnabled = true;
                                          });
                                        } catch (e) {
                                          setState(() {
                                            ignoreTouch = false;
                                            isLoading = false;
                                            isEnabled = true;
                                          });
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: const StadiumBorder(),
                                ),
                                child: isLoading
                                    ? const Padding(
                                        padding: EdgeInsets.all(12),
                                        child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: whiteColor,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Text(
                                          S.of(context).PayNow,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
