import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:kumap/constants/colors.dart';

class CustomSearchBar extends StatelessWidget {
  TextEditingController searchController;
  Function(String) onChanged;
  Function() onPressedBack;
  Function() onPressedClear;

  CustomSearchBar(
      {required this.searchController,
      required this.onChanged,
      required this.onPressedBack,
      required this.onPressedClear});

  @override
  Widget build(BuildContext context) {
    return PlatformTextField(
      controller: searchController,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      material: (_, __) => MaterialTextFieldData(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: '여기서 장소 검색',
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
          ),
          prefixIcon: PlatformIconButton(
            onPressed: onPressedBack,
            materialIcon:
                const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          ),
          suffixIcon: searchController.text.isNotEmpty
              ? PlatformIconButton(
                  onPressed: onPressedClear,
                  materialIcon:
                      const Icon(Icons.clear, color: AppColors.primary),
                )
              : null,
        ),
      ),
      cupertino: (_, __) => CupertinoTextFieldData(
        placeholder: '여기서 장소 검색',
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: AppColors.primary, width: 2.0),
        ),
        prefix: PlatformIconButton(
          onPressed: onPressedBack,
          cupertinoIcon:
              const Icon(Icons.arrow_back_ios, color: AppColors.primary),
        ),
        suffix: searchController.text.isNotEmpty
            ? PlatformIconButton(
                onPressed: onPressedClear,
                cupertinoIcon:
                    const Icon(Icons.clear, color: AppColors.primary),
              )
            : null,
      ),
    );
  }
}
