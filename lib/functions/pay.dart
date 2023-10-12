import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ottu/Networkutils/networkUtils.dart';
import 'package:ottu/models/fetchpaymenttransaction.dart' as c;
import 'package:ottu/screen/payment_details_screen.dart';
import 'package:ottu/widget/cardTile.dart';

class PaymentProcessor {
  static Future createRedirectURL(BuildContext context, String code, sessionID, redirecUrl) async {
    await NetworkUtils.openWebViewForRedirect(redirecUrl, sessionID, code, context);
  }

  static Future processPayment({
    String? publicKeyURL,
    BuildContext? context,
    c.Payment? payment,
    c.Card? card,
    c.PaymentMethod? paymentMethod,
    Function? closeCardView,
    bool? cvvrequired,
    TextEditingController? dateController,
    TextEditingController? cardOnNameController,
    TextEditingController? cvvController,
    TextEditingController? numberController,
    TextEditingController? savedcardcvvController,
  }) async {
    final isvalid = formKey.currentState!.validate();
    if (!isvalid) return;

    if (payType == 'paywithcard') {
      return await handlePaymentScenario(context!, payment!.sessionId.toString(), payType,
          card: c.Card(
            submitUrl: submitURL,
            expiryMonth: dateController!.text.substring(0, 2),
            expiryYear: dateController.text.substring(3, 5),
            nameOnCard: cardOnNameController!.text,
            cvv: cvvController!.text,
            number: numberController!.text,
            saveCard: ischecked,
          )).then((value) {
        closeCardView!();
      });
    } else {
      return PaymentProcessor.createRedirectURL(context!, paymentMethod!.code.toString(), payment!.sessionId.toString(), publicKeyURL);
    }
  }

  static Future handlePaymentScenario(
    BuildContext context,
    String sessionID,
    type, {
    String? savedcardcvv,
    String? publicKeyUrl,
    bool? cvvrequired,
    c.Card? card,
  }) async {
    if (payType == 'paywithsavedcard') {
      await NetworkUtils.pay(
        sessionID,
        card!.submitUrl.toString(),
        context,
        type,
        cardToken: card.token.toString(),
        savedcardcvv: savedcardcvv!,
        paywithcvv: cvvrequired,
      );
    } else {
      await NetworkUtils.pay(
        sessionID,
        card!.submitUrl.toString(),
        context,
        type,
        nameoncard: card.nameOnCard,
        publickeyurl: publicKeyUrl,
        cardnumber: card.number!.replaceAll(' ', ''),
        expiryYear: card.expiryYear,
        expiryMonth: card.expiryMonth,
        cvv: int.parse(card.cvv!),
        savecard: card.saveCard!,
      );
    }
  }
}
