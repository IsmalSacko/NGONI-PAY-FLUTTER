import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/common/utils/kstrings.dart';
import 'package:ngoni_pay/common/utils/widgets/back_button.dart';

class BusinessCreateScreen extends StatefulWidget {
  const BusinessCreateScreen({super.key});

  @override
  State<BusinessCreateScreen> createState() => _BusinessCreateScreenState();
}

class _BusinessCreateScreenState extends State<BusinessCreateScreen> {
  String _selectedType = 'shop';
  bool _isActive = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F4FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            height: size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Bouton retour
                if (GoRouter.of(context).canPop())
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: AppBackButton(),
                    ),
                  ),
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
                      /// Owner ID (temporaire)
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: AppText.kOwnerId,
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// Business name
                      TextField(
                        decoration: InputDecoration(
                          labelText: AppText.kBusinessName,
                          prefixIcon: const Icon(Icons.business_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// Business type (ENUM)
                      DropdownButtonFormField<String>(
                        value: _selectedType,
                        decoration: InputDecoration(
                          labelText: AppText.kBusinessType,
                          prefixIcon: const Icon(Icons.category_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'shop', child: Text('Shop')),
                          DropdownMenuItem(
                            value: 'school',
                            child: Text('School'),
                          ),
                          DropdownMenuItem(
                            value: 'pharmacy',
                            child: Text('Pharmacy'),
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
                          setState(() => _selectedType = value!);
                        },
                      ),
                      const SizedBox(height: 16),

                      /// Address
                      TextField(
                        decoration: InputDecoration(
                          labelText: AppText.kBusinessAddress,
                          prefixIcon: const Icon(Icons.location_on_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// Phone
                      TextField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: AppText.kTelephone,
                          prefixIcon: const Icon(Icons.phone_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// is_active
                      SwitchListTile(
                        value: _isActive,
                        onChanged: (value) {
                          setState(() => _isActive = value);
                        },
                        title: const Text(AppText.kIsActive),
                        activeColor: Kolors.kPrimary,
                        contentPadding: EdgeInsets.zero,
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: POST /businesses
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Kolors.kPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            AppText.kSubmit,
                            style: TextStyle(color: Kolors.kWhite),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
