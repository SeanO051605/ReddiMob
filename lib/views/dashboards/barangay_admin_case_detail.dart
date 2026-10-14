import 'package:flutter/material.dart';

import '../../models/barangay_admin_case.dart';
import '../../services/open_street_map_api.dart';
import '../widgets/barangay_admin_widgets.dart';
import '../widgets/open_street_map.dart';

class BarangayAdminCaseDetail extends StatelessWidget {
  final BarangayAdminCase item;
  final VoidCallback onBack;

  const BarangayAdminCaseDetail({
    super.key,
    required this.item,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          BarangayAdminHeader(
            'Case details',
            showBack: true,
            onBack: onBack,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${item.location} · ${item.time}',
                            style: const TextStyle(
                                fontSize: 10, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: barangayAdminSeverityColor(item.severity)
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item.status,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: barangayAdminSeverityColor(item.severity),
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const SizedBox(
                  height: 160,
                  child: OpenStreetMapView(
                    radius: 10,
                    markers: [
                      OpenStreetMapMarker(
                        point: OpenStreetMapApi.incidentOne,
                        label: 'Emergency location',
                        icon: Icons.emergency,
                      ),
                      OpenStreetMapMarker(
                        point: OpenStreetMapApi.hospital,
                        label: 'Hospital',
                        icon: Icons.local_hospital,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Text('Case summary',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                const Text(
                  'Patient reports difficulty breathing and chest tightening. Needs immediate assessment and possible ambulance dispatch.',
                  style: TextStyle(fontSize: 11, color: Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: barangayAdminRed,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999)),
              ),
              onPressed: () {},
              child: const Text('SOS'),
            ),
          ),
        ],
      );
}
