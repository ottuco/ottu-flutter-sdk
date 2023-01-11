# ottu

The ottu is Flutter SDK makes it quick and easy to build an excellent payment experience in your Flutter app. We provide powerful and customizable UI screens and elements that can be used out-of-the-box to collect your user's payment details. We also expose the low-level APIs that power those UIs so that you can build fully custom experiences.

## Features

**Simplified security**: We make it simple for you to collect sensitive data such as credit card numbers and remain PCI compliant. This means the sensitive data is sent directly to Stripe instead of passing through your server.

**Apple Pay**: We provide a seamless integration with Apple Pay.

**Native UI**: We provide native screens and elements to collect payment details.

<p float="left">
<img src="https://raw.githubusercontent.com/Maninder1991/screens/main/WithCardPayment.png" alt="PaymentUI" align="center"  width="200" height="400"/>
<img src="https://raw.githubusercontent.com/Maninder1991/screens/main/Cardfree.png" alt="PaymentUI" align="center"  width="200" height="400"/>

**Localized**: We support the following localizations: English, Arabic.

#### Recommended usage

If you're selling digital products or services that will be consumed within your app, (e.g. subscriptions, in-game currencies, game levels, access to premium content, or unlocking a full version), you must use Apple's in-app purchase APIs. See the [App Store review guidelines](https://developer.apple.com/app-store/review/guidelines/#payments) for more information. For all other scenarios you can use this SDK to process payments via Stripe.

#### Privacy

The ottu SDK collects data to help us improve our products and prevent fraud. This data is never used for advertising and is not rented, sold, or given to advertisers.

## Requirements

The ottu requires Flutter >=2.0 or above is compatible with android and iOS.

## Getting started

To initialize the SDK you need to create session token. 
You can create session token with our public API [Click here](https://app.apiary.io/iossdk2/editor) to see more detail about our public API.
    
Installation
==========================


***ottu:*** ottu is available through [pub.dev](https://pub.dev). To install
add the following line to your pupspec.yaml:

```dart
ottu: <latest version>
```

In your .dart file, just import ottu package and initalize ottu SDK.

```dart 
import 'package:ottu/ottu.dart';

//extend PaymentDelegate class
class _HomeScreenState extends State<HomeScreen> implements PaymentDelegate {
 // create instance of ottu
  Ottu ottu = Ottu();

 void makePayment() async {
    try {
    //add context,session_id,api_key,merchant_id,paymentDelegate's object and language(ENTER_LANGUAGE_ID_en_or_ar)
      await ottu.open(context, "session_id","api_key",'merchant_id', this, lang: "language");
    } catch (e) {
    //catch errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
            child: ElevatedButton(
                child: const Text('Open SDK'),
                onPressed: () {
                    makePayment();
                },
            ),
        ),
    );
  }

//callback functions
  @override
  void cancelCallback(PaymentStatus paymentStatus) {
    //handle payment fail.
  }
  @override
  void successCallback(PaymentStatus paymentStatus) {
   //handle payment success.
  }
  @override
  void beforeRedirect(PaymentStatus paymentStatus) {
    //handle payment before redirect.
  }
  @override
  void errorCallback(PaymentStatus paymentStatus) {
  //handle error.
  }
}

```
## Inetgrate Apple pay

**Note**: To inetgrate apple pay you need to enable apple pay in capabilites in your project. 


## Licenses

- [ottu License](LICENSE)