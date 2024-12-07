import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class webView extends StatefulWidget {
  String url = "";
  webView(this.url);

  @override
  State<webView> createState() => _webViewState();
}

class _webViewState extends State<webView> {
  String finalUrl = "";
  WebViewController controller = WebViewController();
  @override
  void initState() {
    // TODO: implement initState
    if(widget.url.toString().contains("http://"))
    {
      finalUrl = widget.url.toString().replaceAll("http://", "https://");
    }
    else{
      finalUrl = widget.url;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Your news Are here" , style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
      ),
      body: Container(
        child: WebViewWidget(
          controller: controller
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..loadRequest(Uri.parse(finalUrl)),
        ),
      ),
    );
  }
}
