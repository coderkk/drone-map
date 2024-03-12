import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

const step = 0.2;

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  double _zoom = 9.2;
  double _rotate = 0.0;
  double lat = 0;
  double lng = 0;
  final JoystickMode _joystickMode = JoystickMode.all;
  final _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
          initialCenter: LatLng(lat, lng),
          initialZoom: _zoom,
          interactionOptions:
              const InteractionOptions(flags: ~InteractiveFlag.all)),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () =>
                  launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
            ),
          ],
        ),
        Align(
          alignment: const Alignment(0, 0.8),
          child: Container(
            margin: EdgeInsets.all(24),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Joystick(
                    mode: _joystickMode,
                    listener: (details) {
                      setState(() {
                        _zoom = _zoom + step * details.y;
                        _rotate = _rotate + step * details.x;
                      });
                      LatLng moveTo = LatLng(lat, lng);
                      _mapController.move(moveTo, _zoom);
                      _mapController.rotate(_rotate);
                    },
                  ),
                  Joystick(
                    mode: _joystickMode,
                    listener: (details) {
                      setState(() {
                        lat = lat - step * details.y;
                        lng = lng + step * details.x;
                      });
                      LatLng moveTo = LatLng(lat, lng);
                      _mapController.move(moveTo, _zoom);
                    },
                  ),
                ]),
          ),
        ),
      ],
    );
  }
}
