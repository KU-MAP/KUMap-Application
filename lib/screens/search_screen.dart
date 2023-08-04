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
  final Function(List<OSMNode>) onSearchCompleted;
  final TextEditingController searchController;
  final bool singleResult;

  SearchScreen({
    required this.onSearchCompleted,
    required this.searchController,
    this.singleResult = false,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final API = OSMApiUtil();

  List<OSMNode> _searchResult = [];
  Timer? searchOnStoppedTyping;
  String? _previousSearchQuery;
  late FocusNode _focusNode;

  _onChangeHandler(value) {
    const duration = Duration(milliseconds: 300);
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
    if (_previousSearchQuery != null) {
      widget.searchController.text = _previousSearchQuery!;
    } else {
      widget.searchController.clear();
    }
    Navigator.pop(context);
  }

  _onPressedClear() {
    setState(() {
      widget.searchController.clear();
      _searchResult = [];
    });
  }

  _onSubmitted(value) async {
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping!.cancel());
    }
    API.searchByQuery(value).then((data) => setState(() => {
          _searchResult = data,
          _searchResult.sort((a, b) => a.name.compareTo(b.name)),
          if (_searchResult.isNotEmpty)
            {
              if (_searchResult.length == 1)
                {
                  widget.searchController.text = _searchResult[0].name,
                },
              if (!widget.singleResult || _searchResult.length == 1)
                {
                  widget.onSearchCompleted(_searchResult),
                  Navigator.pop(context),
                }
            }
        }));
  }

  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode.requestFocus();
    super.initState();
    if (widget.searchController.text.isNotEmpty) {
      _previousSearchQuery = widget.searchController.text;
      _onChangeHandler(_previousSearchQuery);
    }
  }

  @override
  void dispose() {
    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.h,
                ),
                child: Column(
                  children: [
                    Padding(
                        padding:
                            EdgeInsets.only(top: 2.h, left: 20.w, right: 20.w),
                        child: CustomSearchBar(
                          searchController: widget.searchController,
                          focusNode: _focusNode,
                          onChanged: _onChangeHandler,
                          onPressedBack: _onPressedBack,
                          onPressedClear: _onPressedClear,
                          onSubmitted: _onSubmitted,
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
                          physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          itemCount: _searchResult.length,
                          itemBuilder: (context, index) {
                            return PlatformListTile(
                              onTap: () => {
                                widget.searchController.text =
                                    _searchResult[index].name,
                                widget
                                    .onSearchCompleted([_searchResult[index]]),
                                Navigator.pop(context),
                              },
                              title: Text(_searchResult[index].name),
                            );
                          }),
                    )),
                  ],
                ))));
  }
}
