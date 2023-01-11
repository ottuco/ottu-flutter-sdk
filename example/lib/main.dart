import 'package:ottu/ottu.dart';
import 'package:flutter/material.dart';
import 'package:ottu/paymentDelegate/paymentDelegate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> implements PaymentDelegate {
  Ottu ottu = Ottu();
  String lan = '';
  void openSDK() async {
    try {
      await ottu.open(
        context,
        'session_id',
        'api_key',
        'merchant_id',
        this,
        lang: lan,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('Open SDK'),
          onPressed: () {
            openSDK();
          },
        ),
      ),
    );
  }

  @override
  void successCallback(String paymentStatus) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        backgroundColor: Colors.green,
        content:
            Text(paymentStatus, style: const TextStyle(color: Colors.white)),
        actions: [
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text('ok'),
          )
        ],
      ),
    );
  }

  @override
  void errorCallback(String paymentStatus) {}

  @override
  void beforeRedirect(String paymentStatus) {}

  @override
  void cancelCallback(String paymentStatus) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        backgroundColor: Colors.red,
        content: Text(
          paymentStatus,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text('ok'),
          )
        ],
      ),
    );
  }
}
