import 'package:flutter/material.dart';
import 'package:ngoni_pay/features/invoice/controller/invoice_controller.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';

class InvoiceScreen extends StatelessWidget {
  final int paymentId;

  const InvoiceScreen({super.key, required this.paymentId});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<InvoiceController>();

    Future.microtask(() {
      if (controller.invoice == null && !controller.isLoading) {
        controller.loadInvoice(paymentId);
      }
    });

    if (controller.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (controller.error != null) {
      return Scaffold(body: Center(child: Text(controller.error!)));
    }

    final invoice = controller.invoice!;
    final date = DateFormat('dd MMM yyyy').format(invoice.createdAt);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Facture'),
        backgroundColor: Kolors.kPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Kolors.kWhite,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                invoice.invoiceNumber,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),

              Text('Date : $date'),
              const Divider(height: 32),

              Text('Montant', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text(
                '${invoice.totalAmount.toStringAsFixed(0)} FCFA',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Kolors.kPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              ElevatedButton.icon(
                onPressed: invoice.pdfPath == null
                    ? null
                    : () {
                        // plus tard : ouvrir / partager PDF
                      },
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Télécharger la facture'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Kolors.kPrimary,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
