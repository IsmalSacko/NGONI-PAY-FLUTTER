import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:ngoni_pay/common/utils/app_style.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:ngoni_pay/features/user/profile_controller.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  XFile? _avatar;
  bool _removeAvatar = false;
  // On charge les données utilisateur existantes dans les champs du formulaire
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final controller = context.read<ProfileController>();
      await controller.loadProfile();

      final user = controller.user;
      if (user != null) {
        nameController.text = user.name;
        phoneController.text = user.phone;
        emailController.text = user.email ?? '';
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _submit(ProfileController controller) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await controller.updateProfile(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      email: emailController.text.trim(),
      avatar: _avatar,
      removeAvatar: _removeAvatar,
    );

    if (!mounted) return;

    if (success) {
      // 1️⃣ Afficher le message EN HAUT
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 50, left: 24, right: 24),
            content: Text(
              textAlign: TextAlign.center,

              'Profil mis à jour avec succès',
              style: TextStyle(
                color: Kolors.kWhite,
                fontWeight: FontWeight.w800,
              ),
            ),
            backgroundColor: Kolors.kSuccess,
            duration: Duration(seconds: 3),
          ),
        );

      // 2️⃣ Attendre un peu
      await Future.delayed(const Duration(seconds: 3));

      // 3️⃣ Revenir en arrière
      if (!mounted) return;
      context.pop();
    } else if (controller.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(controller.error!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileController>();

    if (controller.isLoading && controller.user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (controller.error != null && controller.user == null) {
      return Scaffold(
        body: Center(child: Text('Erreur : impossible de charger le profil')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le profil'),
        backgroundColor: Kolors.kPrimary,
        titleTextStyle: appStyle(22, Kolors.kWhite, FontWeight.bold),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Kolors.kWhite),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // 🧑 AVATAR
              GestureDetector(
                onTap: () => _pickAvatar(context),
                child: CircleAvatar(
                  radius: 44,
                  backgroundColor: Kolors.kPrimary.withValues(alpha: 0.05),
                  backgroundImage: _avatar != null
                      ? FileImage(File(_avatar!.path))
                      : (controller.user?.avatarUrl != null &&
                              controller.user!.avatarUrl!.isNotEmpty)
                          ? NetworkImage(controller.user!.avatarUrl!)
                              as ImageProvider
                          : null,
                  child: (_avatar == null &&
                          (controller.user?.avatarUrl == null ||
                              controller.user!.avatarUrl!.isEmpty))
                      ? Text(
                          controller.user?.name.isNotEmpty == true
                              ? controller.user!.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Kolors.kPrimary,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  TextButton(
                    onPressed: () => _pickAvatar(context),
                    child: const Text('Changer la photo'),
                  ),
                  if (controller.user?.avatarUrl != null &&
                      controller.user!.avatarUrl!.isNotEmpty)
                    TextButton(
                      onPressed: _confirmRemoveAvatar,
                      child: const Text('Supprimer'),
                    ),
                ],
              ),

              const SizedBox(height: 24),

              // 🧾 FORM CARD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Kolors.kWhite,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // 👤 NAME
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Nom complet',
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Le nom est requis'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // 📞 PHONE
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Téléphone',
                          prefixIcon: const Icon(Icons.phone_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Le téléphone est requis'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // ✉️ EMAIL
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email (optionnel)',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 💾 SUBMIT
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
                                  'Enregistrer',
                                  style: TextStyle(
                                    color: Kolors.kWhite,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickAvatar(BuildContext context) async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Caméra'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galerie'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final picked = await picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (picked == null) return;

    final optimized = await _optimizeToJpeg(picked);
    setState(() {
      _avatar = optimized ?? picked;
      _removeAvatar = false;
    });
  }

  Future<XFile?> _optimizeToJpeg(XFile original) async {
    try {
      final bytes = await original.readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded == null) return null;

      final resized = img.copyResize(decoded, width: 1024);
      final jpg = img.encodeJpg(resized, quality: 85);
      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/avatar_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await file.writeAsBytes(jpg, flush: true);
      return XFile(file.path);
    } catch (_) {
      return null;
    }
  }

  Future<void> _confirmRemoveAvatar() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la photo'),
        content: const Text(
          'Voulez-vous supprimer votre photo de profil ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (ok != true) return;
    setState(() {
      _avatar = null;
      _removeAvatar = true;
    });
  }
}
