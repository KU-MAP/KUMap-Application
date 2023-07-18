import 'package:latlong2/latlong.dart';

class OSMNode {
  final String osmType;
  final int osmId;
  final LatLng location;
  final String name;
  final String category;
  final String property;
  final Map<String, dynamic>? extraTags;

  OSMNode({
    required this.osmType,
    required this.location,
    required this.osmId,
    required this.name,
    required this.category,
    required this.property,
    this.extraTags,
  });
}
