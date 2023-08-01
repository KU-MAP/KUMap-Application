import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class CustomSearchBarReadOnly extends StatelessWidget {
  TextEditingController searchController;
  String placeholder;
  Icon? prefixIcon;
  Function() onTap;

  CustomSearchBarReadOnly(
      {required this.searchController,
      this.placeholder = '여기서 장소 검색',
      this.prefixIcon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return PlatformTextField(
      readOnly: true,
      controller: searchController,
      onTap: onTap,
      material: (_, __) => MaterialTextFieldData(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: placeholder,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide.none,
          ),
          prefixIcon: (prefixIcon != null)
              ? PlatformIconButton(materialIcon: prefixIcon)
              : null,
        ),
      ),
      cupertino: (_, __) => CupertinoTextFieldData(
        placeholder: placeholder,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        prefix: (prefixIcon != null)
            ? PlatformIconButton(
                cupertinoIcon: prefixIcon,
              )
            : null,
      ),
    );
  }
}
