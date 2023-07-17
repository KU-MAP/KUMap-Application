import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late FollowOnLocationUpdate _followOnLocationUpdate;
  late StreamController<double?> _followCurrentLocationStreamController;

  final mapController = MapController();

  String MapTileURL = (dotenv.env['SERVER_URL'] as String) +
      (dotenv.env['MAP_TILE_ENDPOINT'] as String);

  @override
  void initState() {
    super.initState();
    _followOnLocationUpdate = FollowOnLocationUpdate.never;
    _followCurrentLocationStreamController = StreamController<double?>();
  }

  @override
  void dispose() {
    _followCurrentLocationStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text('Map'),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: LatLng(37.54189, 127.07767),
          maxBounds: LatLngBounds(
              LatLng(37.5461, 127.0693), LatLng(37.5359, 127.0840)),
          zoom: 17.0,
          minZoom: 14.0,
          maxZoom: 18.0,
          interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
        children: [
          TileLayer(urlTemplate: MapTileURL + '{z}/{x}/{y}.png'),
          CurrentLocationLayer(
            followOnLocationUpdate: _followOnLocationUpdate,
            followCurrentLocationStream:
                _followCurrentLocationStreamController.stream,
          ),
        ],
      ),
    );
  }
}
