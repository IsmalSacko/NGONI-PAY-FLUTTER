import 'package:flutter/material.dart';
import 'package:ngoni_pay/common/utils/app_style.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String checkoutUrl;
  const PaymentWebViewScreen({super.key, required this.checkoutUrl});

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  int _progress = 0;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (!mounted) return;
            setState(() => _progress = progress);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Paiement',
          style: appStyle(20, Kolors.kWhite, FontWeight.bold),
        ),
        backgroundColor: Kolors.kPrimary,
        iconTheme: const IconThemeData(color: Kolors.kWhite),
        bottom: _progress < 100
            ? PreferredSize(
                preferredSize: const Size.fromHeight(3),
                child: LinearProgressIndicator(
                  value: _progress / 100.0,
                  minHeight: 3,
                  backgroundColor: Kolors.kPrimary.withValues(alpha: 0.2),
                  color: Kolors.kWhite,
                ),
              )
            : null,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
