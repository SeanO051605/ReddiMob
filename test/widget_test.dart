import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddiph/controllers/sos_controller.dart';
import 'package:reddiph/main.dart';
import 'package:reddiph/models/emergency.dart';
import 'package:reddiph/views/screens/portal_screen.dart';
import 'package:reddiph/views/screens/barangay_admin_shell.dart';
import 'package:reddiph/views/screens/sos_confirmed_screen.dart';
import 'package:reddiph/views/screens/sos_sending_screen.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class _TestWebViewPlatform extends WebViewPlatform {
  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) =>
      _TestWebViewController(params);

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
    PlatformWebViewWidgetCreationParams params,
  ) =>
      _TestWebViewWidget(params);
}

class _TestWebViewController extends PlatformWebViewController {
  _TestWebViewController(super.params) : super.implementation();

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {}

  @override
  Future<void> setBackgroundColor(Color color) async {}

  @override
  Future<void> setUserAgent(String? userAgent) async {}

  @override
  Future<void> addJavaScriptChannel(JavaScriptChannelParams params) async {}

  @override
  Future<void> loadHtmlString(String html, {String? baseUrl}) async {}
}

class _TestWebViewWidget extends PlatformWebViewWidget {
  _TestWebViewWidget(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) => const SizedBox.expand();
}

void main() {
  setUpAll(() => WebViewPlatform.instance = _TestWebViewPlatform());

  testWidgets('Reddiph app launches and displays the portal screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ReddiphApp());

    await tester.pumpAndSettle();

    expect(find.byType(ReddiphApp), findsOneWidget);
    expect(find.byType(PortalScreen), findsOneWidget);
  });

  testWidgets('Portal screen fits on a compact phone viewport without overflow',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 568));
    addTearDown(() async => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: PortalScreen()));
    await tester.pumpAndSettle();

    expect(find.byType(PortalScreen), findsOneWidget);
    expect(find.text('Barangay Admin'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.binding.setSurfaceSize(const Size(568, 320));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Barangay Admin dashboard and cases fit a compact viewport',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 568));
    addTearDown(() async => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: BarangayAdminShell()));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Cases').last);
    await tester.pumpAndSettle();
    expect(find.text('Difficulty breathing'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Map').last);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Profile').last);
    await tester.pumpAndSettle();
    expect(find.text('Barangay Admin'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Map').last);
    await tester.binding.setSurfaceSize(const Size(568, 320));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Barangay Admin case details remain scrollable on a short screen',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 568));
    addTearDown(() async => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: BarangayAdminShell()));
    await tester.tap(find.text('Cases').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Difficulty breathing'));
    await tester.pumpAndSettle();

    expect(find.text('Case details'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Barangay Admin dashboard and response actions work',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: BarangayAdminShell()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Act now'));
    await tester.pumpAndSettle();
    expect(find.text('Case details'), findsOneWidget);
    expect(find.text('Difficulty breathing'), findsOneWidget);

    await tester.ensureVisible(find.text('SOS'));
    await tester.tap(find.text('SOS'));
    await tester.pumpAndSettle();
    expect(find.text('RESPONSE REQUESTED'), findsOneWidget);
    expect(
      find.text('Demo: response request recorded for this case.'),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    expect(find.byType(PortalScreen), findsOneWidget);
  });

  testWidgets('SOS sending screen auto-confirms after the 3 second countdown',
      (WidgetTester tester) async {
    SosController.I.reset();
    SosController.I.send();

    await tester.pumpWidget(const MaterialApp(home: SosSendingScreen()));
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(SosController.I.stage, EmergencyStage.assigned);
    expect(find.byType(SosConfirmedScreen), findsOneWidget);
  });
}
