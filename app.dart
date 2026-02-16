import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/dependencies/app_pages.dart';
import 'core/dependencies/initial_binding.dart';
import 'core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lumen Caeli',
      theme: AppTheme.themeData(),
      getPages: AppPages.routes,
      initialRoute: AppPages.home,
      initialBinding: InitialBinding(),
    );
  }
}
