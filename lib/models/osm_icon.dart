import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:kumap/models/osm_model.dart';

class IconCircled extends StatelessWidget {
  final Widget icon;
  final double iconSize;
  final Color iconColor;
  final double circleSize;
  final Color circleColor;

  IconCircled({
    required this.icon,
    this.iconSize = 15.0,
    this.iconColor = Colors.white,
    this.circleSize = 15.0,
    this.circleColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: circleColor,
      ),
      child: _buildIcon(),
    );
  }

  Widget _buildIcon() {
    if (icon is Icon) {
      return Icon(
        (icon as Icon).icon,
        size: iconSize,
        color: iconColor,
      );
    } else if (icon is SvgPicture) {
      return ColorFiltered(
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          child: SizedBox(
            width: iconSize,
            height: iconSize,
            child: icon,
          ));
    } else {
      return Container();
    }
  }
}

IconCircled OSMIcon(OSMNode node) {
  String category = node.category;
  String property = node.property;

  const String iconPathPrefix = 'assets/icons/';

  if (category == 'amenity') {
    if (property == 'cafe') {
      return IconCircled(icon: Icon(Icons.local_cafe));
    }
    if (property == 'restaurant') {
      return IconCircled(icon: Icon(Icons.restaurant));
    }
  } else if (category == 'building') {
    return IconCircled(icon: Icon(MdiIcons.domain));
  }
  //TODO: K-Hub SVG 적용

  return IconCircled(icon: Icon(Icons.circle));
}
