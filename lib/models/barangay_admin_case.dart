import 'package:flutter/material.dart';

class BarangayAdminCase {
  final String title;
  final String location;
  final String status;
  final String time;
  final String severity;

  const BarangayAdminCase({
    required this.title,
    required this.location,
    required this.status,
    required this.time,
    required this.severity,
  });
}

const barangayAdminCases = <BarangayAdminCase>[
  BarangayAdminCase(
    title: 'Difficulty breathing',
    location: 'Brgy. Batuan, Purok 2',
    status: 'Active',
    time: 'Today 3:14',
    severity: 'Critical',
  ),
  BarangayAdminCase(
    title: 'Fall injury, elderly',
    location: 'Brgy. Batuan, Purok 6',
    status: 'Closed',
    time: 'Earlier today',
    severity: 'Moderate',
  ),
  BarangayAdminCase(
    title: 'Fever, child',
    location: 'Brgy. Batuan, Purok 1',
    status: 'Closed',
    time: 'Today 08:05',
    severity: 'Low',
  ),
];

const barangayAdminRed = Color(0xFFB1221E);
const barangayAdminBrown = Color(0xFF5A2B2B);
