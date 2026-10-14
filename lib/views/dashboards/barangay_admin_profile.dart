import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../models/barangay_admin_case.dart';

class BarangayAdminProfile extends StatelessWidget {
  final VoidCallback onLogout;

  const BarangayAdminProfile({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.account_circle,
                  size: 54, color: barangayAdminBrown),
              const SizedBox(height: 12),
              const Text('Barangay Admin',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('Admin profile coming soon',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 20),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: kSos),
                onPressed: onLogout,
                child: const Text('Log out'),
              ),
            ],
          ),
        ),
      );
}
