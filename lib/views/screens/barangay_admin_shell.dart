import 'package:flutter/material.dart';

import '../../models/barangay_admin_case.dart';
import '../dashboards/barangay_admin_case_detail.dart';
import '../dashboards/barangay_admin_cases.dart';
import '../dashboards/barangay_admin_dashboard.dart';
import '../dashboards/barangay_admin_map.dart';
import '../dashboards/barangay_admin_profile.dart';

class BarangayAdminShell extends StatefulWidget {
  const BarangayAdminShell({super.key});

  @override
  State<BarangayAdminShell> createState() => _BarangayAdminShellState();
}

class _BarangayAdminShellState extends State<BarangayAdminShell> {
  int _tab = 0;
  BarangayAdminCase? _selectedCase;

  void _openCase(BarangayAdminCase item) {
    setState(() => _selectedCase = item);
  }

  void _closeCase() {
    setState(() => _selectedCase = null);
  }

  @override
  Widget build(BuildContext context) {
    final Widget body;
    if (_selectedCase case final selected?) {
      body = BarangayAdminCaseDetail(item: selected, onBack: _closeCase);
    } else {
      body = switch (_tab) {
        0 => const BarangayAdminDashboard(),
        1 => const BarangayAdminMap(),
        2 => BarangayAdminCases(onCaseSelected: _openCase),
        _ => const BarangayAdminProfile(),
      };
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(child: body),
      bottomNavigationBar: _selectedCase == null
          ? NavigationBar(
              selectedIndex: _tab,
              onDestinationSelected: (index) => setState(() => _tab = index),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                NavigationDestination(
                    icon: Icon(Icons.map_outlined), label: 'Map'),
                NavigationDestination(
                    icon: Icon(Icons.assignment), label: 'Cases'),
                NavigationDestination(
                    icon: Icon(Icons.person_outline), label: 'Profile'),
              ],
            )
          : null,
    );
  }
}
