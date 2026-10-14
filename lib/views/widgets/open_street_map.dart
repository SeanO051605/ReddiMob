import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../services/open_street_map_api.dart';

class OpenStreetMapMarker {
  final LatLng point;
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  const OpenStreetMapMarker({
    required this.point,
    required this.label,
    this.color = const Color(0xFF7A3A22),
    this.icon = Icons.location_on,
    this.onTap,
  });
}

/// Leaflet map backed by OpenStreetMap tiles and contributor attribution.
class OpenStreetMapView extends StatefulWidget {
  final double? height;
  final double radius;
  final LatLng center;
  final double zoom;
  final List<OpenStreetMapMarker> markers;

  const OpenStreetMapView({
    super.key,
    this.height,
    this.radius = 6,
    this.center = OpenStreetMapApi.townCenter,
    this.zoom = 14,
    this.markers = const [],
  });

  @override
  State<OpenStreetMapView> createState() => _OpenStreetMapViewState();
}

class _OpenStreetMapViewState extends State<OpenStreetMapView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    unawaited(_initializeController());
  }

  Future<void> _initializeController() async {
    await _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    await _controller.setBackgroundColor(Colors.white);
    await _controller.setUserAgent(OpenStreetMapApi.userAgent);
    await _controller.addJavaScriptChannel(
      'MarkerSelection',
      onMessageReceived: (message) {
        final index = int.tryParse(message.message);
        if (index != null && index >= 0 && index < widget.markers.length) {
          widget.markers[index].onTap?.call();
        }
      },
    );
    await _controller.loadHtmlString(_document);
  }

  String get _document {
    final center =
        jsonEncode([widget.center.latitude, widget.center.longitude]);
    final markers = jsonEncode([
      for (var i = 0; i < widget.markers.length; i++)
        {
          'lat': widget.markers[i].point.latitude,
          'lon': widget.markers[i].point.longitude,
          'label': widget.markers[i].label,
          'color':
              '#${widget.markers[i].color.toARGB32().toRadixString(16).substring(2)}',
          'symbol': _symbolFor(widget.markers[i].icon),
          'index': i,
        },
    ]).replaceAll('<', r'\u003c').replaceAll('>', r'\u003e');

    return '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
  <link rel="stylesheet" href="${OpenStreetMapApi.leafletCss}">
  <style>
    html, body, #map { width: 100%; height: 100%; margin: 0; padding: 0; }
    .leaflet-div-icon { background: transparent; border: 0; }
    .map-attribution {
      position: absolute; top: 5px; left: 50%; z-index: 1000;
      transform: translateX(-50%); padding: 3px 6px; border-radius: 3px;
      background: #ffffffdd; color: #333; font: 10px sans-serif;
      white-space: nowrap;
    }
    .map-attribution a { color: #1769aa; }
    .map-pin {
      display: flex; align-items: center; justify-content: center;
      width: 28px; height: 28px; border: 2px solid white; border-radius: 50%;
      color: white; background: var(--pin-color); font: 700 14px sans-serif;
      box-shadow: 0 1px 5px #0008;
    }
  </style>
  <script src="${OpenStreetMapApi.leafletJs}"></script>
</head>
<body>
  <div id="map"></div>
  <script>
    const map = L.map('map', {
      zoomControl: true,
      attributionControl: false
    }).setView($center, ${widget.zoom});
    L.tileLayer('${OpenStreetMapApi.tileUrl}', {
      maxZoom: 19
    }).addTo(map);
    const attribution = document.createElement('div');
    attribution.className = 'map-attribution';
    attribution.innerHTML = '&copy; <a href="${OpenStreetMapApi.attributionUrl}">OpenStreetMap contributors</a>';
    document.getElementById('map').appendChild(attribution);
    const points = $markers;
    points.forEach((point) => {
      const icon = L.divIcon({
        className: 'leaflet-div-icon',
        html: '<div class="map-pin" style="--pin-color:' +
          point.color + '">' + point.symbol + '</div>',
        iconSize: [28, 28],
        iconAnchor: [14, 14]
      });
      const marker = L.marker([point.lat, point.lon], { icon }).addTo(map);
      const label = document.createElement('span');
      label.textContent = point.label;
      marker.bindTooltip(label);
      marker.on('click', () => MarkerSelection.postMessage(String(point.index)));
    });
    setTimeout(() => map.invalidateSize(), 100);
  </script>
</body>
</html>
''';
  }

  String _symbolFor(IconData icon) {
    if (icon == Icons.local_hospital) return 'H';
    if (icon == Icons.person) return 'Y';
    if (icon == Icons.emergency) return '!';
    return '•';
  }

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(widget.radius),
        child: SizedBox(
          height: widget.height,
          width: double.infinity,
          child: WebViewWidget(controller: _controller),
        ),
      );
}
