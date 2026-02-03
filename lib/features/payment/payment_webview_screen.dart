import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngoni_pay/common/utils/app_style.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/common/utils/payment_method_label.dart';
import 'package:ngoni_pay/features/payment/service/payment_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String checkoutUrl;
  final int? businessId;
  final int? paymentId;

  const PaymentWebViewScreen({
    super.key,
    required this.checkoutUrl,
    this.businessId,
    this.paymentId,
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  int _progress = 0;
  Timer? _pollTimer;
  bool _isPolling = false;
  String? _lastStatus;

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

    _startPollingIfPossible();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  void _startPollingIfPossible() {
    if (widget.businessId == null || widget.paymentId == null) return;
    _pollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      _checkPaymentStatus();
    });
  }

  Future<void> _checkPaymentStatus() async {
    if (_isPolling || widget.businessId == null || widget.paymentId == null) {
      return;
    }

    _isPolling = true;
    try {
      final payment = await PaymentService.getPaymentById(
        businessId: widget.businessId!,
        paymentId: widget.paymentId!,
      );
      final status = payment.status;
      if (!mounted) return;

      if (_lastStatus != status) {
        _lastStatus = status;
      }

      if (status != 'pending') {
        _pollTimer?.cancel();
        await _showStatusDialog(status);
      }
    } catch (_) {
      // Silent: avoid noisy UI while payment is pending.
    } finally {
      _isPolling = false;
    }
  }

  Future<void> _showStatusDialog(String status) async {
    final isSuccess = status == 'success';
    final title = isSuccess ? 'Paiement réussi' : 'Paiement échoué';
    final message = paymentStatusLabel(status);

    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    if (widget.businessId != null) {
      context.go('/payments/list/${widget.businessId}');
    } else {
      context.pop();
    }
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
