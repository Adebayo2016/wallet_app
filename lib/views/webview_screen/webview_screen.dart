import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewScreen extends StatefulWidget {
  const WebviewScreen({Key? key}) : super(key: key);

  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  // late final WebViewController controller;
  @override
  void initState() {
    // controller = WebViewController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var url="https://www.google.com";
    final  controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse(url));

    return Scaffold(
      body: SizedBox(
        child: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}
