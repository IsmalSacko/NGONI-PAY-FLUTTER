import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngoni_pay/common/utils/kcolors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/business/picker')) return 3;
    if (location.startsWith('/payments')) return 2; // ✅ ICI
    if (location.startsWith('/business/picker')) return 2;
    if (location.startsWith('/business')) return 1;
    if (location.startsWith('/me')) return 4;
    if (location.startsWith('/welcome')) return 0; 

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex(context),
        selectedItemColor: Kolors.kPrimaryLight,
        unselectedItemColor: Kolors.kGray,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/welcome');
              break;
            case 1:
              context.go('/business/create');
              break;
            case 2:
              () async {
                final prefs = await SharedPreferences.getInstance();
                final lastBusinessId = prefs.getInt('last_business_id');

                if (!context.mounted) return;

                context.go(
                  lastBusinessId != null
                      ? '/payments/create/$lastBusinessId'
                      : '/business/picker',
                );
              }();
              break;
            case 3:
              context.go('/business/picker');
              break;
            case 4:
              context.go('/me');
              break;
          }
        },
        items: const [
          
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined),
            label: 'Business',
          ),
          // Service actif 
           BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'Service Actif',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payments_outlined),
            label: 'Encaisser',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),

    );
  }
}
