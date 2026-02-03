import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngoni_pay/common/utils/app_style.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebviewScreen extends StatefulWidget {
  final String url;

  const PaymentWebviewScreen({super.key, required this.url});

  @override
  State<PaymentWebviewScreen> createState() => _PaymentWebviewScreenState();
}

class _PaymentWebviewScreenState extends State<PaymentWebviewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (_) {
                setState(() {
                  _isLoading = true;
                });
              },
              onPageFinished: (_) {
                setState(() {
                  _isLoading = false;
                });
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiement PayDunya'),
        elevation: 0,
        backgroundColor: Kolors.kPrimary,
        titleTextStyle: appStyle(20, Kolors.kWhite, FontWeight.bold),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Kolors.kWhite),
          onPressed: () => context.go('/business/picker'),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const LinearProgressIndicator(
              backgroundColor: Kolors.kGrayLight,
              color: Kolors.kPrimary,
            ),
        ],
      ),
    );
  }
}
