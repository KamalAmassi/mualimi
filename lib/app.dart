import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'core/bindings/initial_binding.dart';
import 'core/constants/app_strings.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

class MualimiApp extends StatelessWidget {
  const MualimiApp({super.key, required this.initialBinding});

  final InitialBinding initialBinding;

  @override
  Widget build(BuildContext context) {
    final settings = initialBinding.settings;
    return Obx(() => GetMaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          initialBinding: initialBinding,
          initialRoute: AppRoutes.splash,
          getPages: AppPages.pages,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: settings.themeMode.value,
          locale: const Locale('ar'),
          supportedLocales: const [Locale('ar')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(settings.fontScale.value)),
            child: Directionality(textDirection: TextDirection.rtl, child: child!),
          ),
        ));
  }
}
