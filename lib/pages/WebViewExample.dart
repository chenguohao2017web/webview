import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WebViewPageState();
  }
}

class WebViewPageState extends State<WebViewPage> {
  TextEditingController controller = TextEditingController();
  var urlString = "http://10.98.18.88:8080/partner/demo/";

  // 定义js channel暴露的方法
  JavascriptChannel _alertJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Toast',
      onMessageReceived: (JavascriptMessage message) {
        print('👏🏼 Message form channel $message');
      }
    );
  }

  final Completer<WebViewController>_controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("web_view")
      ),
      body: WebView(
        initialUrl: urlString,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webviewController) {
          _controller.complete(webviewController);
        },
        // Js channel调用
        javascriptChannels: <JavascriptChannel>[
          _alertJavascriptChannel(context)
        ].toSet(),
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith('js://callApp')) {
            print('🚀 Request navigationn to $request');
            return NavigationDecision.prevent;
          }

          return NavigationDecision.navigate;
        },
        onPageFinished: (String url) {
          print('👉🏻 Page finished loading: $url');
        },
        debuggingEnabled: true,
      )
      // url: urlString,
      // withZoom: false,
    );
  }
}