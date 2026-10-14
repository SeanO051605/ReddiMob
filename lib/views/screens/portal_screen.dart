import 'package:flutter/material.dart';
import '../../core/nav.dart';
import '../../models/role.dart';
import '../widgets/common.dart';
import 'login_screen.dart';

class PortalScreen extends StatelessWidget {
  const PortalScreen({super.key});

  static const _radius = BorderRadius.all(Radius.circular(18));

  Widget tile(BuildContext c, Role r, {required double w, double h = 110}) =>
      Pressable(
        scale: .97,
        child: Material(
          color: r.color,
          borderRadius: _radius,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => Nav.push(c, LoginScreen(role: r)),
            child: SizedBox(
              width: w,
              height: h,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(r.icon, color: Colors.white, size: 24),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                r.desc,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 9,
                                  height: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right,
                            color: Colors.white, size: 18),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(minHeight: constraints.maxHeight - 48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Logo(),
                    const SizedBox(height: 20),
                    const Text(
                      'Emergency Coordination Portal',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 19,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 30),
                    LayoutBuilder(
                      builder: (context, cardConstraints) {
                        final tileWidth = cardConstraints.maxWidth >= 342
                            ? 164.0
                            : (cardConstraints.maxWidth - 14) / 2;
                        return Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 14,
                          runSpacing: 14,
                          children: roles
                              .map((role) => tile(context, role, w: tileWidth))
                              .toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
