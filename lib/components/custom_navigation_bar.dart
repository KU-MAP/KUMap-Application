import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class CustomNavigationBar extends StatelessWidget {
  int currentIndex;
  Function(int) onTap;

  CustomNavigationBar({this.currentIndex = 0, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return PlatformNavBar(
      material: (_, __) => MaterialNavBarData(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: false,
      ),
      currentIndex: currentIndex,
      itemChanged: onTap,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          activeIcon: Icon(Icons.map),
          label: '길찾기',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz_outlined),
          activeIcon: Icon(Icons.more_horiz),
          label: '더보기',
        ),
      ],
    );
  }
}
