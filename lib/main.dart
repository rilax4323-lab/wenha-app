
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const WenhaApp());
}

class WenhaApp extends StatelessWidget {
  const WenhaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'وينه؟',
      home: WenhaHome(),
    );
  }
}

class WenhaHome extends StatefulWidget {
  const WenhaHome({super.key});

  @override
  State<WenhaHome> createState() => _WenhaHomeState();
}

class _WenhaHomeState extends State<WenhaHome> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..loadRequest(
        Uri.parse(
          'https://stellular-dieffenbachia-e137c8.netlify.app',
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
