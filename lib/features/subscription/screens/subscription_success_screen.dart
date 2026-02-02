import 'package:flutter/material.dart';

class SubscriptionSuccessScreen extends StatelessWidget {
  const SubscriptionSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 16),
            const Text("Abonnement activé"),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (r) => r.isFirst);
              },
              child: const Text("Continuer"),
            ),
          ],
        ),
      ),
    );
  }
}
