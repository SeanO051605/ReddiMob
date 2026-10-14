import 'package:flutter/material.dart';

import '../../models/barangay_admin_case.dart';
import '../widgets/barangay_admin_widgets.dart';

class BarangayAdminCases extends StatefulWidget {
  final ValueChanged<BarangayAdminCase> onCaseSelected;

  const BarangayAdminCases({super.key, required this.onCaseSelected});

  @override
  State<BarangayAdminCases> createState() => _BarangayAdminCasesState();
}

class _BarangayAdminCasesState extends State<BarangayAdminCases> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCases = barangayAdminCases
        .where((item) =>
            item.title.toLowerCase().contains(_query) ||
            item.location.toLowerCase().contains(_query))
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        const BarangayAdminHeader('Cases'),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: Text('Active',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFEAEAEA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) =>
                setState(() => _query = value.trim().toLowerCase()),
            decoration: const InputDecoration(
              hintText: 'Search name or complaint',
              border: InputBorder.none,
              icon: Icon(Icons.search, color: Colors.black54),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (filteredCases.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Text('No cases match your search.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54)),
          ),
        for (final item in filteredCases)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => widget.onCaseSelected(item),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: barangayAdminSeverityColor(item.severity),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.location,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.black54),
                            ),
                            const SizedBox(height: 4),
                            Text(item.time,
                                style: const TextStyle(
                                    fontSize: 9, color: Colors.black54)),
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
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: barangayAdminSeverityColor(item.severity),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
