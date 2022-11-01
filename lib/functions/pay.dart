import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ottu/Networkutils/networkUtils.dart';
import 'package:ottu/models/fetchpaymenttransaction.dart' as c;
import 'package:ottu/screen/paymentScreen.dart';
import 'package:ottu/widget/cardTile.dart';

class PayAmount {
  static Future pay(
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

  static Future createRediretURL(
      BuildContext context, String code, sessionID, redirecUrl) async {
    await NetworkUtils.createredirectURL(
      redirecUrl,
      sessionID,
      code,
      context,
    );
  }

  static Future payAmount({
    String? publicKeyURL,
    BuildContext? context,
    c.FetchPaymentTransaction? fetchPaymentTransaction,
    c.Card? card,
    c.PaymentMethod? paymentMethod,
    Function? closeCardView,
    bool? cvvrequired,
    TextEditingController? dateController,
    TextEditingController? cardOnNameController,
    TextEditingController? cvvController,
    TextEditingController? numberController,
    TextEditingController? savedcardcvvController,
    // Function? hideProgress,
  }) async {
    if (payType == 'paywithcard') {
      var isvalid = formKey.currentState!.validate();
      if (!isvalid) return;
      return await pay(
        context!,
        fetchPaymentTransaction!.sessionId.toString(),
        payType,
        publicKeyUrl: publicKeyURL,
        card: c.Card(
          submitUrl: submitURL,
          expiryMonth: dateController!.text.substring(0, 2),
          expiryYear: dateController.text.substring(3, 5),
          nameOnCard: cardOnNameController!.text,
          cvv: cvvController!.text,
          number: numberController!.text,
          saveCard: ischecked,
        ),
      ).then((value) {
        closeCardView!();
      });
    } else if (payType == 'redirectFlow') {
      return PayAmount.createRediretURL(
        context!,
        paymentMethod!.code.toString(),
        fetchPaymentTransaction!.sessionId.toString(),
        fetchPaymentTransaction.submitUrl.toString(),
      );
    } else {
      var isvalid = formKey.currentState!.validate();
      if (!isvalid) return;
      return await pay(
        context!,
        fetchPaymentTransaction!.sessionId.toString(),
        payType,
        card: card,
        cvvrequired: cvvrequired,
        savedcardcvv: savedcardcvvController!.text,
      );
    }
  }
}
