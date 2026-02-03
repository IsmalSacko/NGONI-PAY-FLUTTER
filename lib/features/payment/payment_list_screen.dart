// lib\features\payment\payment_list_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngoni_pay/common/utils/payment_method_label.dart';
import 'package:ngoni_pay/common/utils/widgets/back_button.dart';
import 'package:provider/provider.dart';
import 'package:ngoni_pay/common/utils/app_style.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/common/utils/kstrings.dart';
import 'controller/payment_list_controller.dart';

class PaymentListScreen extends StatefulWidget {
  final int businessId;

  const PaymentListScreen({super.key, required this.businessId});

  @override
  State<PaymentListScreen> createState() => _PaymentListScreenState();
}

class _PaymentListScreenState extends State<PaymentListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PaymentListController>().loadPayments(
        businessId: widget.businessId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PaymentListController>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: AppBackButton(color: Kolors.kWhite),
        ),
        title: const Text(AppText.kPayments),
        backgroundColor: Kolors.kPrimary,
        titleTextStyle: appStyle(24, Kolors.kWhite, FontWeight.bold),
      ),
      body: SafeArea(
        child: controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : controller.error != null
            ? Center(child: Text(controller.error!))
            : controller.payments.isEmpty
            ? const Center(child: Text('Aucun paiement'))
            : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                itemCount: controller.payments.length,
                itemBuilder: (context, index) {
                  final item = controller.payments[index];
                  final isSuccess = item.payment.status == 'success';

                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: isSuccess
                        ? () {
                            // 👉 ICI : OUVERTURE DE LA FACTURE
                            context.push(
                              '/payments/${item.payment.id}/invoice',
                            );
                          }
                        : null, // ❌ rien si pas success
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Kolors.kWhite,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Kolors.kGrayLight.withValues(alpha: 0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 👤 CLIENT
                          Text(
                            item.client.name,
                            style: appStyle(16, Kolors.kDark, FontWeight.bold),
                          ),
                          Text(
                            item.client.phone,
                            style: appStyle(13, Kolors.kGray, FontWeight.w400),
                          ),

                          const Divider(height: 24),

                          // 💰 MONTANT + MÉTHODE
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${item.payment.amount.toStringAsFixed(0)} FCFA',
                                style: appStyle(
                                  18,
                                  Kolors.kPrimary,
                                  FontWeight.bold,
                                ),
                              ),
                              Text(
                                paymentMethodLabel(item.payment.method).toUpperCase(),
                                style: appStyle(
                                  13,
                                  Kolors.kGray,
                                  FontWeight.w500,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // 📌 STATUT
                          _statusBadge(item.payment.status),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    final color = status == 'success'
        ? Colors.green
        : status == 'pending'
        ? Colors.orange
        : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        paymentStatusLabel(status),
        style: appStyle(12, color, FontWeight.bold),
      ),
    );
  }
}
