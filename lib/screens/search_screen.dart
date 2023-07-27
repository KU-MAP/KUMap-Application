import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:kumap/constants/colors.dart';
import 'package:kumap/models/osm_model.dart';
import 'package:kumap/utils/osm_api_util.dart';
import 'package:kumap/components/custom_search_bar.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final API = OSMApiUtil();

  List<OSMNode> _searchResult = [];
  Timer? searchOnStoppedTyping;

  _onChangeHandler(value) {
    const duration = Duration(milliseconds: 400);
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping!.cancel());
    }

    searchOnStoppedTyping = Timer(duration, () async {
      API.searchByQuery(value).then((data) => setState(() => {
            _searchResult = data,
            _searchResult.sort((a, b) => a.name.compareTo(b.name))
          }));
    });
  }

  _onPressedBack() {
    Navigator.pop(context);
  }

  _onPressedClear() {
    setState(() {
      _searchController.clear();
      _searchResult = [];
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        body: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8.h,
            ),
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 2.h, left: 20.w, right: 20.w),
                    child: CustomSearchBar(
                      searchController: _searchController,
                      onChanged: _onChangeHandler,
                      onPressedBack: _onPressedBack,
                      onPressedClear: _onPressedClear,
                    )),
                Padding(
                  padding: EdgeInsets.only(
                    top: 12.h,
                  ),
                  child: Container(
                    color: AppColors.primaryDark,
                    height: 5.h,
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(
                    top: 10.h,
                    left: 20.w,
                    right: 20.w,
                  ),
                  child: ListView.builder(
                      itemCount: _searchResult.length,
                      itemBuilder: (context, index) {
                        return PlatformListTile(
                          title: Text(_searchResult[index].name),
                        );
                      }),
                )),
              ],
            )));
  }
}
