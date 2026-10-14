import 'package:flutter/material.dart';

import '../../controllers/sos_controller.dart';
import '../../core/nav.dart';
import '../../core/theme.dart';
import '../../models/emergency.dart';
import '../../services/open_street_map_api.dart';
import '../widgets/common.dart';
import '../widgets/open_street_map.dart';
import 'arrived_screen.dart';
import 'shell.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final controller = SosController.I;

  @override
  void initState() {
    super.initState();
    if (controller.stage == EmergencyStage.assigned ||
        controller.stage == EmergencyStage.confirmed) {
      // Defer: notifying listeners while the route is still being built
      // triggers "setState() called during build" in other screens.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) controller.startTracking();
      });
    }
  }

  void openTab(int tab) {
    Nav.resetTo(context, Shell(initialTab: tab));
  }

  void _arrive() {
    controller.markArrived();
    Nav.replace(context, const ArrivedScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 16),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      // Only the progress list listens to the controller; the map and
      // ambulance card are const and never rebuilt.
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: OpenStreetMapView(
              height: 160,
              center: OpenStreetMapApi.resident,
              markers: [
                OpenStreetMapMarker(
                  point: OpenStreetMapApi.resident,
                  label: 'Emergency location',
                  color: kSos,
                  icon: Icons.emergency,
                ),
                OpenStreetMapMarker(
                  point: OpenStreetMapApi.hospital,
                  label: 'District Hospital',
                  color: kBrand,
                  icon: Icons.local_hospital,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const _AmbulanceCard(),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 14, 20, 7),
            child: Text(
              'Emergency progress',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              final stage = controller.stage;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _StepTile('1', 'Request', 'SOS received',
                      stage.index >= EmergencyStage.confirmed.index),
                  _StepTile('2', 'Assigned', 'Responder accepted the case',
                      stage.index >= EmergencyStage.assigned.index),
                  _StepTile(
                      '3',
                      'En route',
                      'Responder is travelling to your location',
                      stage.index >= EmergencyStage.tracking.index),
                  _StepTile('4', 'Arrived', 'Responder confirms arrival',
                      stage.index >= EmergencyStage.arrived.index),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: Btn(
                      'CALL RESPONDER',
                      kBrand,
                      fontSize: 10,
                      disabled: stage != EmergencyStage.tracking,
                      onTap: _arrive,
                    ),
                  ),
                ],
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text(
              'Preview: mark as arrived',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 8, color: kSos),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ResidentBottomBar(
        onHome: () => openTab(0),
        onStatus: () {},
        onProfile: () => openTab(2),
      ),
    );
  }
}

class _AmbulanceCard extends StatelessWidget {
  const _AmbulanceCard();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.fromBorderSide(BorderSide(color: Colors.black12)),
            borderRadius: BorderRadius.all(Radius.circular(7)),
          ),
          child: Padding(
            padding: EdgeInsets.all(11),
            child: Row(
              children: [
                Icon(Icons.local_shipping, size: 23),
                SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Barangay ambulance · RB-04',
                        style:
                            TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Kuya Mark is on the way',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Text(
                  '4 min',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      );
}

/// One progress row. Its badge colour fades and the check icon pops in when
/// the stage advances.
class _StepTile extends StatelessWidget {
  final String number, title, subtitle;
  final bool active;
  const _StepTile(this.number, this.title, this.subtitle, this.active);

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 7),
        padding: const EdgeInsets.all(9),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(9)),
          border: Border.fromBorderSide(BorderSide(color: Colors.black12)),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: kMedium,
              curve: Curves.easeOut,
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? kSos : Colors.grey,
                shape: BoxShape.circle,
              ),
              child: Text(
                number,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 8, color: Colors.black54),
                  ),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: kFast,
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: active
                  ? const Icon(Icons.check_circle,
                      key: ValueKey('on'), size: 16)
                  : const SizedBox(key: ValueKey('off'), width: 16, height: 16),
            ),
          ],
        ),
      );
}
