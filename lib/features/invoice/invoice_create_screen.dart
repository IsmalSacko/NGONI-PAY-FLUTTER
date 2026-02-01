import 'package:flutter/material.dart';
import 'package:ngoni_pay/common/utils/app_style.dart';
import 'package:ngoni_pay/features/invoice/controller/invoice_controller.dart';
import 'package:ngoni_pay/features/invoice/pdf/invoice_pdf_template.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class InvoiceScreen extends StatefulWidget {
  final int paymentId;

  const InvoiceScreen({super.key, required this.paymentId});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<InvoiceController>().loadInvoice(widget.paymentId);

      if (!mounted) return;
    });
  }

  Future<void> _shareInvoicePdf(invoice) async {
    final bytes = await InvoicePdfTemplate.generateBytes(invoice);

    await Share.shareXFiles([
      XFile.fromData(
        bytes,
        name: 'facture_${invoice.invoiceNumber}.pdf',
        mimeType: 'application/pdf',
      ),
    ], subject: 'Facture ${invoice.invoiceNumber}');
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<InvoiceController>();

    if (controller.isLoading) {
      return const SafeArea(child: Center(child: CircularProgressIndicator()));
    }

    if (controller.error != null) {
      return SafeArea(child: Center(child: Text(controller.error!)));
    }

    final invoice = controller.invoice!;
    final payment = invoice.payment;
    final client = payment.client;

    final createdDate = DateFormat(
      'dd/MM/yyyy HH:mm',
    ).format(invoice.createdAt);

    final paidDate = payment.paidAt != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(payment.paidAt!)
        : 'Non payé';

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white, size: 28),

        title: Text(
          'Facture',
          style: appStyle(22, Kolors.kWhite, FontWeight.bold),
        ),
        backgroundColor: Kolors.kPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Kolors.kWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🎫 HEADER
                Center(
                  child: Column(
                    children: [
                      const Icon(Icons.receipt_long, size: 40),
                      const SizedBox(height: 8),
                      Text(
                        'REÇU DE PAIEMENT',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                const Divider(),

                _InfoRow(label: 'Facture', value: invoice.invoiceNumber),
                _InfoRow(label: 'Créée le', value: createdDate),

                const Divider(height: 32),

                Text('Client', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 6),
                Text(client?.name ?? '-'),
                Text(client?.phone ?? '-'),

                const Divider(height: 32),

                // 💳 PAIEMENT
                _InfoRow(
                  label: 'Méthode',
                  value: payment.method == 'card'
                      ? 'Carte Bancaire'
                      : payment.method == 'orange_money'
                      ? 'Orange Money'
                      : payment.method == 'moov_money'
                      ? 'Moov Money'
                      : payment.method == 'wave'
                      ? 'Wave'
                      : payment.method == 'cash'
                      ? 'Espèces'
                      : payment.method,
                ),
                _InfoRow(label: 'Payé le', value: paidDate),

                const SizedBox(height: 12),
                _StatusBadge(status: payment.status),

                const Divider(height: 32),

                Center(
                  child: Column(
                    children: [
                      const Text('MONTANT TOTAL'),
                      const SizedBox(height: 6),
                      Text(
                        '${invoice.totalAmount.toStringAsFixed(0)} FCFA',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Kolors.kPrimary,
                            ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 📤 ACTIONS
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          sendInvoiceViaWhatsApp(invoice);
                        },
                        icon: const Icon(Icons.wallet, color: Colors.white),
                        label: const Text(
                          'WhatsApp',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Kolors.kPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          InvoicePdfTemplate.generate(invoice);
                        },
                        icon: const Icon(
                          Icons.picture_as_pdf,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'PDF',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Kolors.kPrimary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // 🔁 PARTAGE SYSTÈME (inchangé)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Share.share('''
                          Reçu de paiement
                          Facture : ${invoice.invoiceNumber}
                          Client : ${client?.name ?? '-'}
                          Montant : ${invoice.totalAmount.toStringAsFixed(0)} FCFA
                          Méthode : ${payment.method}
                          Statut : ${payment.status}
                          ''');
                        },
                        icon: const Icon(Icons.share, color: Colors.white),
                        label: const Text(
                          'Partager autrement',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Kolors.kPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _shareInvoicePdf(invoice);
                        },
                        icon: const Icon(
                          Icons.picture_as_pdf,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Partager le PDF',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Kolors.kPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> sendInvoiceViaWhatsApp(invoice) async {
  final client = invoice.payment.client;
  if (client == null || client.phone.isEmpty) return;

  // ✅ Nettoyage du numéro
  final phone = client.phone
      .replaceAll('+223', '') // Retirer l'indicatif pays (exemple Mali)
      .replaceAll(' ', '') // Retirer les espaces
      .replaceAll('(', '') // Retirer les parenthèses
      .replaceAll('-', ''); // Retirer les tirets

  final message = Uri.encodeComponent('''
🧾 Reçu de paiement
Facture : ${invoice.invoiceNumber}
Client : ${client.name}
Montant : ${invoice.totalAmount.toStringAsFixed(0)} FCFA
Merci pour votre confiance 🙏
''');

  final uri = Uri.parse('https://wa.me/$phone?text=$message');

  // ✅ Vérification réelle
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    // 🔁 FALLBACK PRO
    await Share.share(
      Uri.decodeComponent(message),
      subject: 'Reçu de paiement',
    );
  }
}

// =========================
// 🔘 INFO ROW
// =========================
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// =========================
// 🟢 STATUS BADGE
// =========================
class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case 'success':
        color = Colors.green;
        label = 'PAYÉ';
        break;
      case 'pending':
        color = Colors.orange;
        label = 'EN ATTENTE';
        break;
      default:
        color = Colors.red;
        label = 'ÉCHEC';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
