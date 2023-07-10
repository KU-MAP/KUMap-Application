import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (BuildContext context, Widget? child) {
        return PlatformProvider(
          builder: (context) => PlatformTheme(
            builder: (context) => const PlatformApp(
              localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                DefaultMaterialLocalizations.delegate,
                DefaultWidgetsLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate,
              ],
              title: 'Flutter Platform Widgets',
              home: Scaffold(
                body: Center(
                  child: Text('Hello World!'),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
