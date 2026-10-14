import 'package:flutter/material.dart';

import '../../models/barangay_admin_case.dart';
import '../../services/open_street_map_api.dart';
import '../widgets/barangay_admin_widgets.dart';
import '../widgets/open_street_map.dart';

class BarangayAdminCaseDetail extends StatefulWidget {
  final BarangayAdminCase item;
  final VoidCallback onBack;

  const BarangayAdminCaseDetail({
    super.key,
    required this.item,
    required this.onBack,
  });

  @override
  State<BarangayAdminCaseDetail> createState() =>
      _BarangayAdminCaseDetailState();
}

class _BarangayAdminCaseDetailState extends State<BarangayAdminCaseDetail> {
  bool _responseRequested = false;

  void _requestResponse() {
    if (_responseRequested) return;
    setState(() => _responseRequested = true);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Demo: response request recorded for this case.'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          BarangayAdminHeader(
            'Case details',
            showBack: true,
            onBack: widget.onBack,
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
                            widget.item.title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.item.location} · ${widget.item.time}',
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
                          color:
                              barangayAdminSeverityColor(widget.item.severity)
                                  .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.item.status,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: barangayAdminSeverityColor(
                                widget.item.severity),
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
              onPressed: _responseRequested ? null : _requestResponse,
              child: Text(_responseRequested ? 'RESPONSE REQUESTED' : 'SOS'),
            ),
          ),
        ],
      );
}
