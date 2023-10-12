// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:ottu/Networkutils/networkUtils.dart';
import 'package:ottu/consts/colors.dart';
import 'package:ottu/consts/htmlString.dart';
import 'package:ottu/models/3DSResponse.dart';
import 'package:ottu/screen/3DS/utils/functions.dart';
import 'package:webview_flutter/webview_flutter.dart';

///#DS respose screen
class WebViewWithSocketScreen extends StatefulWidget {
  final ThreeDsResponse? threeDsResponse;

  const WebViewWithSocketScreen({
    Key? key,
    this.threeDsResponse,
  }) : super(key: key);

  @override
  State<WebViewWithSocketScreen> createState() =>
      _WebViewWithSocketScreenState();
}

class _WebViewWithSocketScreenState extends State<WebViewWithSocketScreen> {
  ThreeDsResponse threeDsResponse = ThreeDsResponse();

  @override
  void initState() {
    super.initState();
    setState(() {
      threeDsResponse = NetworkUtils.threeDSResponse;
    });
    WebViewWithSocketScreenFunction.init(
      threeDsResponse.wsUrl.toString(),
      threeDsResponse.referenceNumber.toString(),
      context,
    );
  }

  @override
  void dispose() {
    WebViewWithSocketScreenFunction.dispose();
    super.dispose();
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
        zoomEnabled: true,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          controller.loadHtmlString(
              HtmlString.htmlString(widget.threeDsResponse!.html.toString()));
        },
      )),
    );
  }
}
