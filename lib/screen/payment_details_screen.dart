// ignore_for_file: file_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ottu/Networkutils/networkUtils.dart';
import 'package:ottu/consts/colors.dart';
import 'package:ottu/consts/consts.dart';
import 'package:ottu/models/fetchpaymenttransaction.dart' as c;
import 'package:ottu/screen/mobile_popup_screen.dart';
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
import 'package:ottu/screen/webView/webViewScreen.dart';
import 'package:webview_flutter/webview_flutter.dart';

final paymentCard = PaymentCard();

String submitURL = '';
bool ischecked = false;
c.Card paywithSavedCard = c.Card();
c.PaymentMethod paywithRedirectFlow = c.PaymentMethod();
var payType = '';

class PaymentDetailsScreen extends StatefulWidget {
  final c.Payment? payment;
  final String? type;
  final BuildContext? context;
  const PaymentDetailsScreen({
    Key? key,
    this.payment,
    this.type,
    this.context,
  }) : super(key: key);

  @override
  State<PaymentDetailsScreen> createState() => PaymentDetailsScreenState();
}

class PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  //controllers
  final cvvController = TextEditingController();
  final cardOnNameController = TextEditingController();
  final dateController = TextEditingController();
  final savedcardcvvControllers = <TextEditingController>[TextEditingController()];
  final TextEditingController numberController = TextEditingController(text: '');
  bool isEnable = true;
  String fees = '';
  var cvvString = '';
  String feesCurrencyCode = '';
  String total = '';
  bool cvvrequired = false;
  bool ignoreTouch = false;
  int savedcvvindex = 0;
  String fee_description = '';
  c.Payment payment = c.Payment();


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
    for (var element in widget.payment!.paymentMethods!) {
      if (element.flow == 'card') {
        numberController.addListener(_getCardTypeFrmNumber);
        break;
      }
    }

    if (widget.type != '1') {
      setState(() {
        payType = '';
        payment = widget.payment!;
        customerId = widget.payment!.customerId.toString();
        amount = widget.payment!.amount.toString();
        sessionId = payment.sessionId.toString();
        currencyCode = payment.currencyCode.toString();
      });
    } else {
      setState(() {
        payType = '';
        payment = NetworkUtils.payment;
        customerId = NetworkUtils.payment.customerId.toString();
        amount = NetworkUtils.payment.amount.toString();
        sessionId = NetworkUtils.payment.sessionId.toString();
        currencyCode = payment.currencyCode.toString();
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
    if (payment.cards!.isNotEmpty) {
      savedcardcvvControllers.clear();
      List.generate(payment.cards!.length, (index) {
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

  Widget buildShimmer(double height) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ShimmerWidget.rect(height: height),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: canvasColor,
        body: ScreenUtilInit(
          builder: (context, child) {
            return ListView(
              children: [
                Form(
                  key: formKey,
                  child: IgnorePointer(
                    ignoring: ignoreTouch,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        if (isEnable) buildShimmer(100.0),
                        const SizedBox(height: 20),
                        if (!isEnable) buildTotalAmountContainer(context),
                        const SizedBox(height: 10),
                        if (isEnable) buildShimmer(200.0),
                        if (!isEnable) buildPaymentMethodsContainer(context),
                        const SizedBox(height: 10),
                        if (isEnable) buildShimmer(50.0),
                        if (!isEnable) buildPayNowButtonContainer(context),
                        const SizedBox(height: 10),
                        if (fees.isNotEmpty && double.parse(fees) > 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "+$fees $feesCurrencyCode ",
                                      style: const TextStyle(color: primaryColor),
                                    ),
                                    TextSpan(
                                      text: fee_description,
                                      style: const TextStyle(color: blackColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Container buildTotalAmountContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: shadowColor, width: 3),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (total.isNotEmpty && double.parse(fees) > 0)
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
                          text: payment.amount.toString(),
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' ${payment.currencyCode}',
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
            if (total.isNotEmpty && double.parse(fees) > 0)
              const SizedBox(
                height: 5,
              ),
            if (fees.isNotEmpty && double.parse(fees) > 0)
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
            if (fees.isNotEmpty && double.parse(fees) > 0)
              const SizedBox(
                height: 5,
              ),
            if (fees.isNotEmpty && double.parse(fees) > 0)
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
            if (Platform.isIOS && payment.applePayAvailable!)
              const SizedBox(
                height: 10,
              ),

            if (Platform.isIOS && payment.applePayAvailable!)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: blackColor,
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  ApplePay().paywithApple(
                    payment.applePayConfig!.validationUrl.toString(),
                    widget.context!,
                    payment.applePayConfig!.currencyCode!,
                    payment.applePayConfig!.countryCode!,
                    payment.applePayConfig!.amount!,
                    payment.applePayConfig!.shopName!,
                    payment.applePayConfig!.paymentUrl.toString(),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
            if (Platform.isIOS && payment.applePayAvailable!)
              const SizedBox(
                height: 15,
              ),
            if (Platform.isIOS && payment.applePayAvailable! && payment.applePayConfig!.fee!.isNotEmpty && double.parse(payment.applePayConfig!.fee!) > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "+${payment.applePayConfig!.fee ?? ""} ${payment.applePayConfig!.currencyCode} ",
                          style: const TextStyle(
                            color: primaryColor,
                          ),
                        ),
                        TextSpan(
                          text: payment.applePayConfig!.fee_description ?? '',
                          style: const TextStyle(
                            color: blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            if (Platform.isIOS && payment.applePayAvailable! && payment.cards!.isNotEmpty)
              const SizedBox(
                height: 15,
              ),
            if (Platform.isIOS && payment.applePayAvailable! && payment.cards!.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Flexible(
                    child: Divider(
                      color: dividerColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
            if (Platform.isIOS && payment.applePayAvailable! && payment.cards!.isNotEmpty)
              const SizedBox(
                height: 14,
              ),

            ///---- End Apple pay

            ///Saved Card
            if (payment.cards!.isNotEmpty)
              Text(
                S.of(context).SavedCards,
                style: TextStyle(
                  fontSize: 15.sp,
                ),
              ),
            SizedBox(
              height: 5.sp,
            ),
            if (payment.cards!.isNotEmpty)
              Text(
                S.of(context).Listofallcardssaved,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: secondaryColor,
                ),
              ),
            if (payment.cards!.isNotEmpty)
              const SizedBox(
                height: 7,
              ),
            if (payment.cards!.isNotEmpty)
              ListView.builder(
                key: const ValueKey('savedcards'),
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: payment.cards!.length,
                shrinkWrap: true,
                itemBuilder: (ctx, i) {
                  return InkWell(
                    onTap: () {
                      if (!payment.cards![i].isSelected) {
                        for (var element in payment.cards!) {
                          setState(() {
                            element.isSelected = false;
                          });
                        }
                        for (var element in payment.paymentMethods!) {
                          setState(() {
                            element.isRedirectSelected = false;
                          });
                        }
                        for (var element in payment.paymentMethods!) {
                          setState(() {
                            element.isSelected = false;
                          });
                        }
                      }
                      setState(() {
                        payment.cards![i].isSelected = true;
                        if (payment.cards![i].isSelected) {
                          paywithSavedCard = payment.cards![i];
                          payType = '';
                          savedcvvindex = i;
                          cvvrequired = payment.cards![i].requiredCvv!;
                          for (var methods in payment.paymentMethods!) {
                            if (methods.code == payment.cards![i].pgCode) {
                              setState(() {
                                fee_description = methods.fee_description ?? '';
                                fees = methods.fee.toString();
                                feesCurrencyCode = methods.currencyCode.toString();
                                amount = methods.amount.toString();
                                total = payment.amount.toString();
                              });
                            }
                          }
                        }
                        if (!payment.cards![i].isSelected) {
                          setState(() {
                            total = '';
                            feesCurrencyCode = '';
                            amount = payment.amount.toString();
                            fees = '';
                            payType = '';
                          });
                        }
                      });
                    },
                    child: SavedCard(
                      cvvStatus: setPayButtonEnabled,
                      cvvcontroller: savedcardcvvControllers[i],
                      paywithcvv: payment.cards![i].requiredCvv!,
                      isSelected: payment.cards![i].isSelected,
                      brand: payment.cards![i].brand.toString(),
                      expiryMonth: payment.cards![i].expiryMonth.toString(),
                      expiryYear: payment.cards![i].expiryYear.toString(),
                      onCardTap: () {
                        Dialogs().showDialogs(
                          context,
                          () async {
                            NetworkUtils().deleteCard(
                              payment.cards![i].deleteUrl.toString(),
                              () {
                                setState(() {
                                  payment.cards!.removeAt(i);
                                });
                              },
                              context,
                            );
                          },
                          '${payment.cards![i].brand} ${payment.cards![i].number}',
                        );
                      },
                      number: payment.cards![i].number.toString(),
                    ),
                  );
                },
              ),

            ///---- End Saved Card
          ],
        ),
      ),
    );
  }

  Container buildPaymentMethodsContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: shadowColor, width: 3),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
              physics: const NeverScrollableScrollPhysics(),
              key: const ValueKey('methods'),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: payment.paymentMethods!.length,
              itemBuilder: (ctx, i) {
                final currentPaymentMethod = payment.paymentMethods![i];
                final canSaveCard = i < payment.paymentMethods!.length ? currentPaymentMethod.cansavecard : false;

                return CardTile(
                  cansavecard: canSaveCard ?? false,
                  paybuttonCallback: setPayButtonEnabled,
                  oncardtap: () {
                    payment.paymentMethods?.forEach((transaction) {
                      transaction.isSelected = false;
                      transaction.isRedirectSelected = false;
                    });

                    payment.cards?.forEach((card) {
                      card.isSelected = false;
                    });

                    switch (currentPaymentMethod.flow) {
                      case 'card':
                        currentPaymentMethod.isSelected = true;
                        payType = '';
                        break;
                      case 'stc_pay':
                        currentPaymentMethod.isRedirectSelected = true;
                        break;
                      case 'ottu_pg':
                        currentPaymentMethod.isRedirectSelected = true;
                        break;
                      default:
                        currentPaymentMethod.isRedirectSelected = true;
                        currentPaymentMethod.flow = '';
                        break;
                    }

                    submitURL = currentPaymentMethod.submitUrl.toString(); // currentPaymentMethod.flow == 'card' ? currentPaymentMethod.submitUrl.toString() : currentPaymentMethod.redirectUrl.toString();

                    fees = currentPaymentMethod.fee.toString();
                    fee_description = currentPaymentMethod.fee_description ?? '';
                    amount = currentPaymentMethod.amount.toString();
                    total = amount;
                    feesCurrencyCode = currentPaymentMethod.currencyCode.toString();
                    paywithRedirectFlow = currentPaymentMethod;
                    payType = currentPaymentMethod.flow == 'card' ? '' : currentPaymentMethod.flow.toString();

                    setState(() {});
                  },
                  cardNumberController: numberController,
                  cvvController: cvvController,
                  nameOnCardController: cardOnNameController,
                  dateController: dateController,
                  image: currentPaymentMethod.icon.toString(),
                  cardname: currentPaymentMethod.name.toString(),
                  charges: currentPaymentMethod.fee.toString(),
                  isCardFlowSelected: currentPaymentMethod.isSelected,
                  isChecked: currentPaymentMethod.ischecked,
                  setIsChecked: () {
                    setState(() {
                      currentPaymentMethod.ischecked = !currentPaymentMethod.ischecked;
                      ischecked = currentPaymentMethod.ischecked;
                    });
                  },
                  isRedirectSelected: currentPaymentMethod.isRedirectSelected,
                  flow: currentPaymentMethod.flow!,
                  customerID: payment.customerId.toString(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Container buildPayNowButtonContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: () async {
          if (payType == "stc_pay" && payment.paymentMethods != null) {
            showMobileOTPPopup(context, paywithRedirectFlow);
          } else if(paywithRedirectFlow.flow == 'ottu_pg') {
            String url = paywithRedirectFlow.redirectUrl ?? '';
            if(url.contains('?')) url = url + '&channel=mobile_sdk';
            else url = url + '?channel=mobile_sdk';
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => WebViewScreen(
                  webviewURL: url,
                  sessionId: payment.sessionId.toString(),
                ),
              ),
            );
          } else /*if (cvvString.length != 3 && payType.isEmpty)*/ {
            try {
              await processPayment();
            } catch (e) {
              // Handle the exception if needed
            } finally {
              _setButtonState(false, false, true);
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: const StadiumBorder(),
        ),
        child: loadingButtonContent(context),
      ),
    );
  }

  void _setButtonState(bool ignoreTouch, bool isLoading, bool isEnabled) {
    setState(() {
      ignoreTouch = ignoreTouch;
      isLoading = isLoading;
      isEnabled = isEnabled;
    });
  }

  Widget loadingButtonContent(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            color: whiteColor,
            strokeWidth: 2,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(14.0),
        child: Text(
          S.of(context).PayNow,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      );
    }
  }

  Future<void> processPayment() async {
    setState(() {
      ignoreTouch = true;
      isLoading = true;
      isEnabled = false;
    });

    try {
      await PaymentProcessor.processPayment(
        publicKeyURL: submitURL,
        context: widget.context,
        savedcardcvvController: savedcardcvvControllers[savedcvvindex],
        cvvrequired: cvvrequired,
        payment: payment,
        card: paywithSavedCard,
        cardOnNameController: cardOnNameController,
        cvvController: cvvController,
        dateController: dateController,
        numberController: numberController,
        paymentMethod: paywithRedirectFlow,
        closeCardView: () {
          if (payType == 'paywithcard') {
            for (var element in payment.paymentMethods!) {
              setState(() {
                payType = '';
                element.isSelected = false;
              });
            }
          }
        },
      );
    } catch (e) {
      // Handle the exception if needed
    } finally {
      setState(() {
        ignoreTouch = false;
        isLoading = false;
        isEnabled = true;
      });
    }
  }
}
