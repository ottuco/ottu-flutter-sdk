// ignore_for_file: file_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ottu/consts/colors.dart';
import 'package:ottu/screen/webView/utils/webviewfunctions.dart';
import 'package:webview_flutter/webview_flutter.dart';

///webview Screen
class WebViewScreen extends StatefulWidget {
  final String? webviewURL;
  final String sessionId;
  const WebViewScreen({Key? key, this.webviewURL, required this.sessionId})
      : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: SafeArea(
        child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            controller.loadUrl(widget.webviewURL.toString());
          },
          navigationDelegate: (request) {
            ///handle webview
            WebViewFunctions.navigate(context, request.url, widget.sessionId);
            return NavigationDecision.navigate;
          },


        ),
      ),
    );
  }
}
