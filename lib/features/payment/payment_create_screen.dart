import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngoni_pay/common/utils/app_style.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/common/utils/kstrings.dart';
import 'package:ngoni_pay/common/utils/payment_method_label.dart';
import 'package:ngoni_pay/common/utils/widgets/back_button.dart';
import 'package:ngoni_pay/features/payment/controller/payment_controller.dart';
import 'package:ngoni_pay/features/payment/models/payment_create_model.dart';
import 'package:ngoni_pay/features/payment/widgets/business_choised_name.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentCreateScreen extends StatefulWidget {
  final int businessId;
  const PaymentCreateScreen({super.key, required this.businessId});

  @override
  State<PaymentCreateScreen> createState() => _PaymentCreateScreenState();
}

class _PaymentCreateScreenState extends State<PaymentCreateScreen> {
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  Timer? _debounce;
  String _method = 'orange_money';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PaymentController>().loadBusiness(widget.businessId);
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    nameController.dispose();
    amountController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _submit(PaymentController controller) async {
    final phone = phoneController.text.trim();
    final name = nameController.text.trim();
    final amountText = amountController.text.trim().replaceAll(',', '.');
    final amount = double.tryParse(amountText);

    if (phone.isEmpty || phone.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir un numéro valide.')),
      );
      return;
    }
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir le nom du client.')),
      );
      return;
    }
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir un montant valide.')),
      );
      return;
    }

    final payload = PaymentCreateModel(
      phone: phone,
      name: name,
      amount: amount,
      currency: 'XOF',
      method: _method,
    );

    final result = await controller.createPayment(
      businessId: widget.businessId,
      payload: payload,
    );

    if (!mounted) return;

    if (result != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('last_business_id', widget.businessId);

      if (!mounted) return;

      final checkoutUrl = result.checkoutUrl ?? '';
      if (checkoutUrl.trim().isNotEmpty) {
        context.push(
          '/payments/checkout',
          extra: {
            'checkoutUrl': checkoutUrl,
            'businessId': widget.businessId,
            'paymentId': result.paymentId,
          },
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          // mettre une marge en bas
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          behavior: SnackBarBehavior.floating,
          content: SizedBox(child: Text('Paiement créé avec succès')),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 800),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 800));

      if (!mounted) return;
      context.go('/business/picker');
    } else if (controller.error != null) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erreur de paiement'),
          content: Text(controller.error!),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PaymentController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau Paiement'),
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: AppBackButton(color: Kolors.kWhite),
        ),
        backgroundColor: Kolors.kPrimary,
        titleTextStyle: appStyle(24, Kolors.kWhite, FontWeight.bold),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 20),
                ),
              ),

              if (controller.business != null)
                BusinessChoiseName(controller: controller),
              SizedBox(
                height: 100,
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: const Image(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 24),
                            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppText.kLocalPaymentHint,
                  style: appStyle(13, Kolors.kGray, FontWeight.w500),
                ),
              ),
              const SizedBox(height: 16),

              // CARD
              Container(
                padding: const EdgeInsets.all(20),
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
                  children: [
                    // PHONE
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        if (_debounce?.isActive ?? false) _debounce!.cancel();

                        _debounce = Timer(
                          const Duration(milliseconds: 600),
                          () async {
                            if (value.length < 8)
                              return; // Minimum length check

                            final controller = context
                                .read<PaymentController>();

                            final name = await controller.findClientName(
                              businessId: widget.businessId,
                              phone: value.trim(),
                            );

                            if (!mounted) return;

                            if (name != null) {
                              nameController.text = name;
                            } else {
                              nameController.clear();
                            }
                          },
                        );
                      },
                      decoration: InputDecoration(
                        labelText: AppText.kPhone,
                        helperText: AppText.kMaliPhoneHelper,
                        prefixIcon: const Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      enabled: !context.watch<PaymentController>().clientFound,
                      decoration: InputDecoration(
                        labelText: AppText.kClientName,
                        prefixIcon: const Icon(Icons.person_outline),
                        suffixIcon:
                            context.watch<PaymentController>().clientFound
                            ? const Icon(
                                Icons.check_circle,
                                color: Kolors.kSuccess,
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // AMOUNT
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: AppText.kAmount,
                        prefixIcon: const Icon(Icons.attach_money),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // METHOD
                    DropdownButtonFormField<String>(
                      initialValue: _method,
                      decoration: InputDecoration(
                        labelText: AppText.kPaymentMethod,
                        prefixIcon: const Icon(Icons.credit_card_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'cash', child: Text('Espèces')),
                        DropdownMenuItem(
                          value: 'orange_money',
                          child: Text('Orange Money'),
                        ),
                        DropdownMenuItem(
                          value: 'moov_money',
                          child: Text('Moov Money'),
                        ),
                        DropdownMenuItem(value: 'wave', child: Text('Wave')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _method = value);
                        }
                      },
                    ),

                    const SizedBox(height: 24),

                    // SUBMIT
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: controller.isLoading
                            ? null
                            : () => _submit(controller),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Kolors.kPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: controller.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                AppText.kSubmit,
                                style: TextStyle(color: Kolors.kWhite),
                              ),
                      ),
                      
                    ),
                                        const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Méthode sélectionnée : ${paymentMethodLabel(_method)}',
                        style: appStyle(12, Kolors.kGray, FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
