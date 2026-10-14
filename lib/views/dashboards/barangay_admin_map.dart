import 'package:flutter/material.dart';

import '../../models/barangay_admin_case.dart';
import '../../services/open_street_map_api.dart';
import '../widgets/barangay_admin_widgets.dart';
import '../widgets/open_street_map.dart';

class BarangayAdminMap extends StatelessWidget {
  const BarangayAdminMap({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
        child: Column(
          children: [
            const BarangayAdminHeader('Live Map'),
            Expanded(
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: OpenStreetMapView(
                      radius: 18,
                      markers: [
                        OpenStreetMapMarker(
                          point: OpenStreetMapApi.incidentOne,
                          label: 'Incident 1',
                          icon: Icons.emergency,
                        ),
                        OpenStreetMapMarker(
                          point: OpenStreetMapApi.incidentTwo,
                          label: 'Incident 2',
                          icon: Icons.emergency,
                        ),
                        OpenStreetMapMarker(
                          point: OpenStreetMapApi.incidentThree,
                          label: 'Incident 3',
                          icon: Icons.emergency,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 18,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: barangayAdminRed,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'Live',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
              ),
              child: const Text(
                'Brgy. Batuan right now\nAmbulance available near Dr. Jose P. Rizal Hospital',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11, color: Colors.black87),
              ),
            ),
          ],
        ),
      );
}
