import 'package:flutter/material.dart';
import 'package:ngoni_pay/common/utils/app_style.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/features/payment/controller/payment_controller.dart';

class BusinessChoiseName extends StatelessWidget {
  const BusinessChoiseName({
    super.key,
    required this.controller,
  });

  final PaymentController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Kolors.kPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.storefront_outlined, color: Kolors.kPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              controller.business!.name,
              style: appStyle(16, Kolors.kPrimary, FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}