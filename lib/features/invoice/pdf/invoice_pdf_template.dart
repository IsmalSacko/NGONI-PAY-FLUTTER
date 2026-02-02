import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class InvoicePdfTemplate {
  // ==========================================================
  // 🔥 1. APERÇU / IMPRESSION (INCHANGÉ POUR TOI)
  // ==========================================================
  static Future<void> generate(invoice) async {
    final pdf = await _buildPdf(invoice);

    await Printing.layoutPdf(onLayout: (_) async => pdf.save());
  }

  // ==========================================================
  // 🔥 2. NOUVEAU : BYTES DU PDF (POUR PARTAGE)
  // ==========================================================
  static Future<Uint8List> generateBytes(invoice) async {
    final pdf = await _buildPdf(invoice);
    return pdf.save();
  }

  // ==========================================================
  // 🧱 CONSTRUCTION DU PDF (LOGIQUE CENTRALE)
  // ==========================================================
  static Future<pw.Document> _buildPdf(invoice) async {
    final fontRegular = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Inter_24pt-Regular.ttf'),
    );

    final fontBold = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Inter_28pt-Bold.ttf'),
    );

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(base: fontRegular, bold: fontBold),
    );

    final payment = invoice.payment;
    final client = payment.client;

    // 🔐 LOGO SÉCURISÉ (ANTI-CRASH)
    pw.ImageProvider? logo;
    try {
      logo = await imageFromAssetBundle('assets/images/logo.png');
    } catch (_) {
      logo = null;
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (_) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              _header(logo, invoice),
              pw.SizedBox(height: 20),
              pw.Divider(),

              _section('INFORMATIONS', [
                _row('Facture', invoice.invoiceNumber),
                _row(
                  'Date',
                  DateFormat('dd/MM/yyyy HH:mm').format(invoice.createdAt),
                ),
              ]),

              _section('CLIENT', [
                _row('Nom', client?.name ?? '-'),
                _row('Téléphone', client?.phone ?? '-'),
              ]),

              _section('PAIEMENT', [
                _row('Méthode', payment.method),
                _row('Statut', payment.status.toUpperCase()),
              ]),

              pw.SizedBox(height: 24),
              pw.Divider(),

              _total(invoice.totalAmount),

              pw.Spacer(),
              _footer(),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  // ==========================================================
  // 🔧 HELPERS (INCHANGÉS)
  // ==========================================================

  static pw.Widget _header(pw.ImageProvider? logo, invoice) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        if (logo != null) pw.Image(logo, height: 50),

        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              'REÇU DE PAIEMENT',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 6),
            pw.Text(invoice.invoiceNumber, style: pw.TextStyle(fontSize: 14)),
          ],
        ),
      ],
    );
  }

  static pw.Widget _section(String title, List<pw.Widget> children) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 16),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  static pw.Widget _row(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 14)),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static pw.Widget _total(double amount) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(border: pw.Border.all(width: 1)),
      child: pw.Column(
        children: [
          pw.Text('MONTANT TOTAL', style: pw.TextStyle(fontSize: 14)),
          pw.SizedBox(height: 8),
          pw.Text(
            '${amount.toStringAsFixed(0)} FCFA',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static pw.Widget _footer() {
    return pw.Center(
      child: pw.Text(
        'Merci pour votre confiance 🙏',
        style: pw.TextStyle(fontSize: 14, color: PdfColors.grey),
      ),
    );
  }
}
