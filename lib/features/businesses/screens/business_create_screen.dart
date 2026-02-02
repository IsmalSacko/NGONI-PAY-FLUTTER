import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngoni_pay/common/utils/app_style.dart';
import 'package:ngoni_pay/features/businesses/models/business_model.dart';

import 'package:provider/provider.dart';

import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/common/utils/kstrings.dart';
import 'package:ngoni_pay/common/utils/widgets/back_button.dart';
import 'package:ngoni_pay/features/businesses/controllers/business_controller.dart';

class BusinessCreateScreen extends StatefulWidget {
  const BusinessCreateScreen({super.key});

  @override
  State<BusinessCreateScreen> createState() => _BusinessCreateScreenState();
}

class _BusinessCreateScreenState extends State<BusinessCreateScreen> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  String _selectedType = 'shop';

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit(BusinessController controller) async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le nom du business est obligatoire')),
      );
      return;
    }

    final business = BusinessModel(
      name: nameController.text.trim(),
      type: _selectedType,
      address: addressController.text.trim(),
      phone: phoneController.text.trim(),
    );

    final success = await controller.createBusiness(business);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entreprise créée avec succès')),
      );
      context.go('/welcome');
    } else if (controller.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(controller.error!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BusinessController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouveau Business"),
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: AppBackButton(color: Kolors.kWhite),
        ),
        backgroundColor: Kolors.kPrimary,
        titleTextStyle: appStyle(24, Kolors.kWhite, FontWeight.w700),
      ),
      //backgroundColor: const Color(0xFFF6F4FF),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    SizedBox(
                      //height: size.height - 120,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.storefront_outlined,
                            size: 64,
                            color: Kolors.kPrimary,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            AppText.kCreateBusiness,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Kolors.kDark,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // CARD
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Kolors.kWhite,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Kolors.kGrayLight.withValues(
                                    alpha: 0.4,
                                  ),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // NAME
                                TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    labelText: AppText.kBusinessName,
                                    prefixIcon: const Icon(
                                      Icons.business_outlined,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // TYPE
                                DropdownButtonFormField<String>(
                                  initialValue: _selectedType,
                                  decoration: InputDecoration(
                                    labelText: AppText.kBusinessType,
                                    prefixIcon: const Icon(
                                      Icons.category_outlined,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'shop',
                                      child: Text('Boutique'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'school',
                                      child: Text('École'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'pharmacy',
                                      child: Text('Pharmacie'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'garage',
                                      child: Text('Garage'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'service',
                                      child: Text('Service'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => _selectedType = value);
                                    }
                                  },
                                ),
                                const SizedBox(height: 16),

                                // ADDRESS
                                TextField(
                                  controller: addressController,
                                  decoration: InputDecoration(
                                    labelText: AppText.kBusinessAddress,
                                    prefixIcon: const Icon(
                                      Icons.location_on_outlined,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // PHONE
                                TextField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    labelText: AppText.kTelephone,
                                    prefixIcon: const Icon(
                                      Icons.phone_outlined,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
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
                                            style: TextStyle(
                                              color: Kolors.kWhite,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
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
