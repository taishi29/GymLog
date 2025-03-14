import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContactFormScreen extends StatefulWidget {
  @override
  _ContactFormScreenState createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(
          "https://docs.google.com/forms/d/e/1FAIpQLSfCsgJCyb3nbkpIdXri5T5b3MXYe6_TjA3Gujcn6s6-gBo2Hg/viewform?usp=header"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("お問い合わせ"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _controller.reload(); // リロードボタン
            },
          )
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
