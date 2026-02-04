import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngoni_pay/common/utils/app_style.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/core/enums/payment_status.dart';
import 'package:ngoni_pay/features/payment/controller/payment_list_controller.dart';
import 'package:provider/provider.dart';

class TransactionsScreen extends StatefulWidget {
  final int businessId;
  final DateTime? date;
  final PaymentStatus? status;

  const TransactionsScreen({
    super.key,
    required this.businessId,
    this.date,
    this.status,
  });

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentListController>().loadPayments(
        businessId: widget.businessId,
        date: widget.date,
        status: widget.status?.name,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transactions',
          style: appStyle(24, Kolors.kWhite, FontWeight.bold),
        ),
        backgroundColor: Kolors.kPrimary,
        iconTheme: const IconThemeData(color: Colors.white, size: 28),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long, size: 28, color: Colors.white),
            tooltip: 'Gérer les paiements',
            color: Kolors.kWhite,
            onPressed: () {
              context.go('/payments/list/${widget.businessId}');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<PaymentListController>(
          builder: (_, controller, __) {
            // 🔄 LOADING
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // ❌ ERREUR
            if (controller.error != null) {
              return Center(child: Text(controller.error!));
            }

            // 📭 EMPTY STATE
            if (controller.payments.isEmpty) {
              return const Center(
                child: Text(
                  'Aucune transaction',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                // 🔍 FILTRES ACTIFS
                if (widget.date != null)
                  Text(
                    'Date : ${widget.date!.toLocal().toString().split(' ')[0]}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                if (widget.status != null)
                  Text(
                    'Statut : ${widget.status!.name}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                // 👉 BOUTON VUE COMPLÈTE (UNIQUEMENT SI FILTRE)
                if (widget.date != null || widget.status != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 12),
                    child: TextButton.icon(
                      onPressed: () {
                        context.go('/payments/list/${widget.businessId}');
                      },
                      icon: const Icon(
                        Icons.open_in_new,
                        size: 20,
                        color: Kolors.kPrimary,
                      ),
                      label: Text(
                        'Ouvrir la vue complète',
                        style: appStyle(16, Kolors.kPrimary, FontWeight.w500),
                      ),
                    ),
                  ),

                // 📄 LISTE DES TRANSACTIONS
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.payments.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, index) {
                      final item = controller.payments[index];
                      final payment = item.payment;

                      return ListTile(
                        title: Text(
                          '${payment.amount.toStringAsFixed(0)} FCFA',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          payment.method == 'orange_money'
                              ? 'Orange Money'
                              : payment.method == 'moov_money'
                              ? 'Moov Money'
                              : payment.method == 'wave'
                              ? 'Wave'
                              : payment.method == 'card'
                              ? 'Carte Bancaire'
                              : payment.method == 'cash'
                              ? 'Espèces'
                              : payment.method,
                        ),
                        trailing: Text(
                          payment.status == 'success'
                              ? 'Réussi'
                              : payment.status == 'pending'
                              ? 'En attente'
                              : 'Échoué',
                          style: TextStyle(
                            fontSize: item.payment.status == 'success'
                                ? 16
                                : 15,
                            color: payment.status == 'success'
                                ? Colors.green
                                : payment.status == 'pending'
                                ? Colors.orange
                                : Colors.red,
                          ),
                        ),
                        onTap: () {
                          // 👉 futur : PaymentDetailScreen
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
          ),
        ),
      ),
    );
  }
}
