import 'package:flutter/material.dart';

import '../../models/barangay_admin_case.dart';

class BarangayAdminDashboard extends StatelessWidget {
  final VoidCallback onActNow;

  const BarangayAdminDashboard({super.key, required this.onActNow});

  Widget _statCard(String label, String value, String sub) => Container(
        constraints: const BoxConstraints(minHeight: 88),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFEEEFF2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 10, color: Colors.black54)),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 4),
            Text(sub,
                style: const TextStyle(fontSize: 9, color: Colors.black54)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning,'
        : hour < 18
            ? 'Good Afternoon,'
            : 'Good Evening,';

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(greeting,
                        style: const TextStyle(
                            fontSize: 11, color: Colors.black54)),
                    const Text(
                      'Brgy. Batuan',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Barangay La Paz, Batangas City',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 9, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const CircleAvatar(
                radius: 18,
                backgroundColor: barangayAdminBrown,
                child: Text('B',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Material(
            color: const Color(0xFFF3F3F3),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: onActNow,
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        size: 14, color: barangayAdminRed),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'A SOS not opened for 2:14:45',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 10, color: Colors.black87),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Act now',
                      style: TextStyle(
                          fontSize: 10,
                          color: barangayAdminRed,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _statCard('Active cases', '5', 'Live')),
              const SizedBox(width: 10),
              Expanded(child: _statCard('Responders on duty', '12', 'Ready')),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _statCard('Volunteers available', '14', 'Ready')),
              const SizedBox(width: 10),
              Expanded(child: _statCard('Vehicles ready', '6', 'Road')),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          height: 160,
          margin: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: barangayAdminBrown,
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ],
    );
  }
}
