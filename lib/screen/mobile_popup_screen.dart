import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ottu/Networkutils/networkUtils.dart';
import 'package:ottu/consts/consts.dart';
import 'package:ottu/models/fetchpaymenttransaction.dart';
import '../generated/l10n.dart';
import 'package:ottu/consts/colors.dart';

class MobilePopup extends StatefulWidget {
  PaymentMethod? paymentMethod;
  MobilePopup(this.paymentMethod, {Key? key}) : super(key: key);

  @override
  _MobilePopupState createState() => _MobilePopupState();
}

class _MobilePopupState extends State<MobilePopup> {
  String mobileNumber = '';
  String otp = '';
  bool isLoading = false;
  bool showOtpField = false;
  bool showPhoneNumberError = false;
  String showPhoneNumberErrorMessage = '';
  bool showOtpError = false;
  bool isSaveCard = false;

  TextEditingController otpController = TextEditingController(); // Add this line
  void clearOtpField() {
    setState(() {
      otp = ''; // Clear OTP
      otpController.clear(); // Clear the controller
    });
  }

  void processOtp() {
    print('OTP submitted: $otp');
  }

  @override
  void dispose() {
    otpController.dispose(); // Dispose the controller when the state is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: primaryColor),
      ),
      debugShowCheckedModeBanner: false,
      home: Builder(builder: (context) => AlertDialog(
        title: Text(showOtpField ? S.of(context).EnterOTP : S.of(context).EnterMobileNumber),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!showOtpField)
              TextField(
                onChanged: (value) {
                  setState(() {
                    mobileNumber = value;
                    showPhoneNumberError = false; // Reset the error message
                  });
                },
                enabled: !isLoading && !showOtpField,
                keyboardType: TextInputType.phone,
                maxLength: 12,
                decoration: InputDecoration(labelText: S.of(context).MobileNumber),
              ),

            if ((customerId ?? '').isNotEmpty && !showOtpField && widget.paymentMethod?.cansavecard == true)
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .05,
                    child: Checkbox(
                        activeColor: Colors.black,
                        value: isSaveCard,
                        visualDensity: VisualDensity.compact,
                        onChanged: (value) {
                          setState(() {
                            isSaveCard = !isSaveCard;
                          });
                        }
                    ),
                  ),
                  SizedBox(width: 7,),
                  Text(S.of(context).ClickToSaveYourCard)
                ],
              ),
            if (showPhoneNumberErrorMessage.isNotEmpty)
              Text(
                showPhoneNumberErrorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            if (showOtpField)
              TextField(
                controller: otpController,
                onChanged: (value) {
                  setState(() {
                    otp = value;
                    showOtpError = false; // Reset the error message
                  });
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: S.of(context).EnterOTP),
              ),
            if (showOtpError)
              Text(
                S.of(context).SomethingWentWrongPleaseTryAgain,
                style: TextStyle(color: Colors.red),
              ),
            if (isLoading) const CircularProgressIndicator(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: isLoading || mobileNumber.isEmpty || mobileNumber.length < 8 || mobileNumber.length > 15 || (showOtpField && otp.isEmpty)
                ? null
                : () async {
              setState(() => isLoading = true);
              if (!showOtpField) {
                final phoneNumberResponse = await submitPhoneNumberAndHandleResponse(
                  context,
                  NetworkUtils.payment.sessionId.toString(),
                  mobileNumber,

                );
                setState(() {
                  showOtpField = phoneNumberResponse == 'sent';
                  showPhoneNumberErrorMessage = showOtpField ? '' : phoneNumberResponse;
                });
              } else {
                final otpResponse = await submitOTP(context, NetworkUtils.payment.sessionId.toString(), otp);

                setState(() {
                  showOtpError = otpResponse != 'Success';
                });
              }
              setState(() => isLoading = false);
            },
            child: Text(S.of(context).SendOTP),
          ),
          TextButton(
            onPressed: isLoading ? null : () {
              Navigator.of(context).pop();
              // Future.delayed(Duration(milliseconds: 1000), () {
              //   Get.back();
              // });
            },
            child: Text(S.of(context).Close),
          ),
        ],
      ),),
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

  Future<String> submitPhoneNumberAndHandleResponse(BuildContext context, String sessionId, String phoneNumber) async {
    final phoneNumberResponse = await submitPhoneNumber(context, NetworkUtils.payment.sessionId.toString(), phoneNumber);
    return phoneNumberResponse;
  }

  Future<String> submitPhoneNumber(BuildContext context, String sessionId, String phoneNumber) async {
    String apiUrl = widget.paymentMethod?.submitUrl ?? '';
    final headers = {
      "Content-Type": "application/json",
      "Authorization": 'Api-Key ${NetworkUtils.token}',
    };

    final payload = jsonEncode({
      "pg_code": "stc_pay", // The payment gateway code
      "session_id": sessionId, // The session ID from your previous call
      "customer_phone": phoneNumber,
      "save_card": isSaveCard,
    });

    try {
      final response = await http.post(Uri.parse(apiUrl), body: payload, headers: headers);
      final responseJson = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return 'sent'; // Return a status indicating OTP sent
      } else if (response.statusCode == 400) {
        return '${responseJson['message']}';
      } else if (response.statusCode == 401) {
        return '${responseJson['detail']}';
      } else {
        return 'error'; // Return a status indicating OTP sending failed
      }
    } catch (e) {
      // Handle the error here
      print('An error occurred: $e');
      return 'error'; // Return a status indicating OTP sending failed
    }
  }

  Future<String> submitOTP(BuildContext context, String sessionId, String otp) async {
    String apiUrl = widget.paymentMethod?.paymentUrl ?? '';
    final headers = {
      "Content-Type": "application/json",
      "Authorization": 'Api-Key ${NetworkUtils.token}',
    };
    final body = jsonEncode({'session_id': sessionId, 'otp': otp});

    try {
      final response = await http.post(Uri.parse(apiUrl), body: body, headers: headers);
      if (response.statusCode == 200) {

        NetworkUtils.paymentDelegates!.successCallback(response.body);
        Navigator.of(context).pop();
        Navigator.popUntil(context, (Route<dynamic> predicate) => predicate.isFirst);

        final responseData = jsonDecode(response.body);
        return handleResponse(responseData);
      } else if (response.statusCode == 401) {
        final errorData = jsonDecode(response.body);
        //final errorDetail = errorData['detail'];
        handleUnauthorizedError(context, errorData);
        return 'Unauthorized Error';
      } else {
        return 'Other Error';
      }

    } catch (error) {
      return 'Exception Error';
    }
  }

  String handleResponse(Map<String, dynamic> responseData) {
    final paymentGatewayInfo = responseData['payment_gateway_info'];
    final status = responseData['status'];
    final errorMessage = responseData['message'];

    switch (status) {
      case 'success':
        // Handle success case here
        return 'Success'; // You can modify this return value as needed
      case 'canceled':
        // Handle cancellation case here
        return 'Cancelled'; // You can modify this return value as needed
      case 'error':
        // Handle error case here
        return 'Error: $errorMessage'; // You can modify this return value as needed
      default:
        // Handle other cases if needed
        return 'Unknown Status'; // You can modify this return value as needed
    }
  }

  void handleUnauthorizedError(BuildContext context, dynamic errorData) {
    // Show the SnackBar
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Error: ${errorData.toString()}'),
      duration: Duration(seconds: 5),
    ));

    // Dismiss the AlertDialog
    //Navigator.of(context).pop();
  }
}

void showMobileOTPPopup(BuildContext context, PaymentMethod paymentMethod, {bool canSaveCard = false}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return MobilePopup(paymentMethod);
    },
  );

  
}
