import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../controllers/splash_controller.dart';
import '../widgets/splash_background.dart';
import '../widgets/splash_brand.dart';
import '../widgets/splash_footer.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: context.colors.hero,
        body: const Stack(
          fit: StackFit.expand,
          children: [
            SplashBackground(),
            Column(children: [Expanded(child: SplashBrand()), SplashFooter()]),
          ],
        ),
      ),
    );
  }
}
