import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:kumap/components/custom_navigation_bar.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        body: SafeArea(child: _buildPage()),
        bottomNavBar: CustomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabSelected,
        ).build(context) as PlatformNavBar);
  }

  Widget _buildPage() {
    switch (_currentIndex) {
      case 0:
        return Container();
      case 1:
        return Container();
      default:
        return Container();
    }
  }
}
