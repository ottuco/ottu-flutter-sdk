import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ottu/consts/consts.dart';
import 'package:ottu/consts/imagePath.dart';
import 'package:ottu/generated/l10n.dart';
import '../consts/colors.dart';

///all dialogs that used in ottu sdk.
class Dialogs {
  Dialogs();
  Future showDialogs(
      BuildContext context, Future Function() function, String cardName) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => MaterialApp(
        locale: currentLocale,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Scaffold(
          backgroundColor: blackColor.withOpacity(.2),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.only(top: 24),
                  child: Column(
                    children: [
                      Text(
                        S().Remove + ' : $cardName',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        S().ClickConfirmifyoudontwantthispaymentmethodtobedisplayedinyourpaymentoptions,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      const Divider(),
                      SizedBox(
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    bottom: 20,
                                    top: 13,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    S().Cancel,
                                    style: const TextStyle(
                                      color: secondaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 20,
                              color: secondaryColor,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  function().then((value) {
                                    Dialogs().showProgressDialog(context);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    bottom: 20,
                                    top: 13,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    S().Confirm,
                                    style: const TextStyle(
                                      color: redColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future showSuccessDialog(BuildContext context, String currencyCode) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        Future.delayed(
          const Duration(seconds: 3),
          () {
            Navigator.of(context).pop();
            Navigator.popUntil(
              context,
              (Route<dynamic> predicate) => predicate.isFirst,
            );
          },
        );
        return Scaffold(
          backgroundColor: blackColor.withOpacity(.2),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.only(top: 24),
                  child: Column(
                    children: [
                      Image.asset(
                        imagePath + 'success.png',
                        package: 'ottu',
                        scale: 3,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        S().Congratulationsyourtransferwascompletedsuccessfully,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      Text(
                        amount.toString() + currencyCode + ' ' + S().ispaid,
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 17, color: primaryColor),
                      ),
                      const Divider(),
                      SizedBox(
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Navigator.popUntil(
                                      context,
                                      (Route<dynamic> predicate) =>
                                          predicate.isFirst);
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    bottom: 20,
                                    top: 13,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    S().Ok,
                                    style: const TextStyle(
                                      color: blackColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future showCardSaveDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(
          S().Withsavedcardyoucanskipenteringcarddetailsinyournexttransaction,
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(
              primary: primaryColor,
              side: const BorderSide(color: primaryColor),
            ),
            child: Text(
              S().Ok,
            ),
          ),
        ],
      ),
    );
  }

  Future showFailDialog(BuildContext context) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        Future.delayed(
          const Duration(seconds: 3),
          () {
            Navigator.of(context).pop();
            Navigator.popUntil(
              context,
              (Route<dynamic> predicate) => predicate.isFirst,
            );
          },
        );
        return Scaffold(
          backgroundColor: blackColor.withOpacity(.2),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.only(top: 24),
                  child: Column(
                    children: [
                      Image.asset(
                        imagePath + 'failed.png',
                        package: 'ottu',
                        scale: 3,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        S().sorryyourpaymentisfailedpleasecheckyourcarddetails,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      const Divider(),
                      SizedBox(
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Navigator.popUntil(
                                    context,
                                    (Route<dynamic> predicate) =>
                                        predicate.isFirst,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    bottom: 20,
                                    top: 13,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    S().Ok,
                                    style: const TextStyle(
                                      color: blackColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future showProgressDialog(BuildContext context) async {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
        return Scaffold(
          backgroundColor: blackColor.withOpacity(.2),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(
                  color: primaryColor,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
