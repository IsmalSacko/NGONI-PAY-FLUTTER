import 'package:flutter/material.dart';
import 'package:ngoni_pay/common/utils/widgets/back_button.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:ngoni_pay/common/utils/app_style.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/features/businesses/business_controller.dart';

class BusinessPickerScreen extends StatefulWidget {
  const BusinessPickerScreen({super.key});

  @override
  State<BusinessPickerScreen> createState() => _BusinessPickerScreenState();
}

class _BusinessPickerScreenState extends State<BusinessPickerScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<BusinessController>().loadBusinesses());
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BusinessController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choisir une entreprise'),
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: AppBackButton(color: Kolors.kWhite),
        ),
        backgroundColor: Kolors.kPrimary,
        titleTextStyle: appStyle(24, Kolors.kWhite, FontWeight.bold),
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: controller.businesses.length,
              itemBuilder: (context, index) {
                final business = controller.businesses[index];

                return InkWell(
                  onTap: () {
                    //  ICI on passe le businessId au paiement
                    context.go('/payments/create/${business.id}');
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
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
                    child: Row(
                      children: [
                        const Icon(
                          Icons.storefront_outlined,
                          color: Kolors.kPrimary,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                business.name,
                                style: appStyle(
                                  16,
                                  Kolors.kDark,
                                  FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                business.address ?? '',
                                style: appStyle(
                                  13,
                                  Kolors.kGray,
                                  FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Kolors.kGray),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
