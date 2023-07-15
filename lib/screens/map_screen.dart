import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class MapScreen extends StatelessWidget {
  String MapTileURL = (dotenv.env['SERVER_URL'] as String) +
      (dotenv.env['MAP_TILE_ENDPOINT'] as String);

  final mapController = MapController();

  MapScreen({Key? key}) : super(key: key);

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
              LatLng(37.5453, 127.0697), LatLng(37.5370, 127.0830)),
          zoom: 17.0,
          minZoom: 15.0,
          maxZoom: 19.0,
        ),
        children: [
          TileLayer(urlTemplate: MapTileURL + '{z}/{x}/{y}.png'),
        ],
      ),
    );
  }
}
