import 'package:flutter/material.dart';

import '../../models/barangay_admin_case.dart';

class BarangayAdminProfile extends StatelessWidget {
  const BarangayAdminProfile({super.key});

  @override
  Widget build(BuildContext context) => const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.account_circle, size: 54, color: barangayAdminBrown),
              SizedBox(height: 12),
              Text('Barangay Admin',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              SizedBox(height: 8),
              Text('Admin profile coming soon',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54)),
            ],
          ),
        ),
      );
}
