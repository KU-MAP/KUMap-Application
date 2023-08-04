import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:animations/animations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

import 'package:kumap/constants/colors.dart';
import 'package:kumap/models/osm_model.dart';
import 'package:kumap/components/custom_search_bar_read_only.dart';
import 'package:kumap/components/osm_marker.dart';
import 'package:kumap/screens/search_screen.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late FollowOnLocationUpdate _followOnLocationUpdate;
  late StreamController<double?> _followCurrentLocationStreamController;
  final TextEditingController _searchController = TextEditingController();

  final mapController = MapController();

  bool _isQueryResultVisible = false;
  List<OSMNode> data = [];

  String MapTileURL = (dotenv.env['SERVER_URL'] as String) +
      (dotenv.env['MAP_TILE_ENDPOINT'] as String);

  void handleQuerySearchResult(List<OSMNode> result) {
    setState(() {
      data = result;
      _isQueryResultVisible = true;
    });
  }

  void ClearMarker() {
    setState(() {
      data = [];
      _isQueryResultVisible = false;
      _searchController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _followOnLocationUpdate = FollowOnLocationUpdate.never;
    _followCurrentLocationStreamController = StreamController<double?>();
  }

  @override
  void dispose() {
    _followCurrentLocationStreamController.close();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent));
    return Stack(children: [
      FlutterMap(
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
          MarkerLayer(
            markers: data.map((node) => OSMMarker(node, () {})).toList(),
          )
        ],
      ),
      SafeArea(
          child: Padding(
              padding: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
              child: OpenContainer(
                transitionDuration: Duration(milliseconds: 400),
                transitionType: ContainerTransitionType.fade,
                openBuilder: (context, action) => SearchScreen(
                  searchController: _searchController,
                  onSearchCompleted: handleQuerySearchResult,
                ),
                closedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                closedBuilder: (context, action) => CustomSearchBarReadOnly(
                  onTap: action,
                  prefixIcon: _isQueryResultVisible
                      ? PlatformIconButton(
                          onPressed: ClearMarker,
                          materialIcon: Icon(Icons.arrow_back_ios,
                              color: AppColors.primary),
                          cupertinoIcon: Icon(Icons.arrow_back_ios,
                              color: AppColors.primary),
                        )
                      : PlatformIconButton(
                          materialIcon:
                              Icon(Icons.search, color: AppColors.primary),
                          cupertinoIcon:
                              Icon(Icons.search, color: AppColors.primary)),
                  searchController: _searchController,
                ),
              )))
    ]);
  }
}
