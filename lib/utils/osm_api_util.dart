import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:kumap/models/osm_model.dart';

class OSMApiUtil {
  Future<List<OSMNode>> searchByQuery(String query) async {
    final String SearchPhotonURL = (dotenv.env['SERVER_URL'] as String) +
        (dotenv.env['SEARCH_PHOTON_ENDPOINT'] as String);

    final response =
        await http.get(Uri.parse('$SearchPhotonURL?q=$query&lang=ko'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      List<OSMNode> result = [];
      if (data['features'] != null && data['features'] is List) {
        for (var feature in data['features']) {
          final properties = feature['properties'];
          final geometry = feature['geometry']['coordinates'];

          final LatLng location = LatLng(geometry[1], geometry[0]);

          String osmType = properties['osm_type'] ?? '';
          int osmId = properties['osm_id'] ?? 0;
          String name = properties['name'] ?? '';
          String category = properties['osm_key'] ?? '';
          String property = properties['osm_value'] ?? '';

          OSMNode osmNode = OSMNode(
            osmType: osmType,
            osmId: osmId,
            location: location,
            name: name,
            category: category,
            property: property,
          );

          result.add(osmNode);
        }
      }
      return result;
    } else {
      throw Exception('Fail to load data from server');
    }
  }

  Future<OSMNode> fetchDetailById(String osmType, int osmId) async {
    final String FetchDetailURL = (dotenv.env['SERVER_URL'] as String) +
        (dotenv.env['SEARCH_NOMINATIM_DETAIL_ENDPOINT'] as String);
    final response = await http.get(Uri.parse(
        '$FetchDetailURL?osmtype=$osmType&osmid=$osmId&polygon_geojson=1&extratags=1'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final geometry = data['centroid']['coordinates'];

      final LatLng location = LatLng(geometry[1], geometry[0]);

      String name = data['localname'] ?? '';
      String category = data['category'] ?? '';
      String property = data['type'] ?? '';

      Map<String, dynamic> extraTags = {};
      extraTags['ref'] = data['names']['ref'] ?? null;
      extraTags['image'] = data['extratags']['image'] ?? null;
      if (osmType == 'R' || osmType == 'W') {
        extraTags['polygon'] = data['geometry']['coordinates'] ?? null;
      }

      OSMNode result = OSMNode(
        osmType: osmType,
        osmId: osmId,
        location: location,
        name: name,
        category: category,
        property: property,
        extraTags: extraTags,
      );

      return result;
    } else {
      throw Exception('Fail to load data from server');
    }
  }

  Future<List<OSMNode>> searchByKeyword(String keyword) async {
    final String SearchOverpassURL = (dotenv.env['SERVER_URL'] as String) +
        (dotenv.env['SEARCH_OVERPASS_ENDPOINT'] as String);

    String category = '';
    String property = '';

    if (keyword == 'cafe') {
      category = 'amenity';
      property = 'cafe';
    } else if (keyword == 'convenience') {
      category = 'shop';
      property = 'convenience';
    } else if (keyword == 'restaurant') {
      category = 'amenity';
      property = 'restaurant';
    } else {
      throw Exception('Wrong Keyword');
    }
    String OverpassQuery = 'node["$category"="$property"]';
    // TODO: 공부공간, 휴게실, 프린터, 따릉이, 금융, 식당, 편의시설

    final response = await http.get(Uri.parse(
        '$SearchOverpassURL?data=[out:json];$OverpassQuery["name"!=""];out;'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      List<OSMNode> result = [];
      if (data['elements'] != null && data['elements'] is List) {
        for (var element in data['elements']) {
          final LatLng location = LatLng(element['lat'], element['lon']);

          String osmType = 'N';
          int osmId = element['id'] ?? 0;
          String name = element['tags']['name'] ?? '';

          OSMNode osmNode = OSMNode(
            osmType: osmType,
            osmId: osmId,
            location: location,
            name: name,
            category: category,
            property: property,
          );

          result.add(osmNode);
        }
      }
      return result;
    } else {
      throw Exception('Fail to load data from server');
    }
  }
}
