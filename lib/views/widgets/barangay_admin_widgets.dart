import 'package:flutter/material.dart';

import '../../models/barangay_admin_case.dart';

class BarangayAdminHeader extends StatelessWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;

  const BarangayAdminHeader(
    this.title, {
    super.key,
    this.showBack = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
        child: Row(
          children: [
            if (showBack)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: InkWell(
                  onTap: onBack,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE7E7E7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chevron_left, color: Colors.black),
                  ),
                ),
              )
            else
              const SizedBox(width: 4),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      );
}

Color barangayAdminSeverityColor(String severity) => switch (severity) {
      'Critical' => barangayAdminRed,
      'Moderate' => const Color(0xFF6E7B8B),
      _ => const Color(0xFF7B8B7F),
    };
