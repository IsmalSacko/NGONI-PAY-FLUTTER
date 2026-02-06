import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ngoni_pay/common/utils/app_style.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/common/utils/kstrings.dart';
import 'package:ngoni_pay/common/utils/widgets/error_banner.dart';
import 'package:ngoni_pay/features/businesses/controllers/business_controller.dart';

class BusinessListScreen extends StatefulWidget {
  const BusinessListScreen({super.key});

  @override
  State<BusinessListScreen> createState() => _BusinessListScreenState();
}

class _BusinessListScreenState extends State<BusinessListScreen> {
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
        title: const Text(AppText.kBusinesses),
        elevation: 0,
        backgroundColor: Kolors.kPrimary,
        titleTextStyle: appStyle(24, Kolors.kWhite, FontWeight.bold),
      ),
      body: SafeArea(
        child: controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : controller.error != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ErrorBanner(message: controller.error!),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                itemCount: controller.businesses.length,
                itemBuilder: (context, index) {
                  final b = controller.businesses[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.storefront_outlined,
                              size: 32,
                              color: Kolors.kPrimary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                b.name,
                                style: appStyle(
                                  18,
                                  Kolors.kDark,
                                  FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        _line("Type", b.type),
                        _line("Adresse", b.address ?? "-"),
                        _line("Téléphone", b.phone ?? "-"),

                        if (b.owner != null) ...[
                          const Divider(height: 32),
                          Text(
                            AppText.kOwner,
                            style: appStyle(14, Kolors.kDark, FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          _line("Nom", b.owner!.name),
                          _line("Téléphone", b.owner!.phone),
                        ],
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _line(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: appStyle(14, Kolors.kDark, FontWeight.w400),
          children: [
            TextSpan(
              text: "$label : ",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
