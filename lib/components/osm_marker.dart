import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:kumap/models/osm_model.dart';
import 'package:kumap/models/osm_icon.dart';

Marker OSMMarker(OSMNode node, VoidCallback onMarkerTap) {
  return Marker(
    point: node.location,
    builder: (ctx) => GestureDetector(
      onTap: onMarkerTap,
      child: OSMIcon(node),
    ),
  );
}
