import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../controllers/welcome_controller.dart';
import '../widgets/onboarding_step_indicator.dart';
import '../widgets/welcome_dimens.dart';
import '../widgets/welcome_feature_card.dart';
import '../widgets/welcome_header.dart';
import '../widgets/welcome_name_field.dart';
import '../widgets/welcome_next_button.dart';
import '../widgets/welcome_strings.dart';

class WelcomePage extends GetView<WelcomeController> {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: colors.background,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const WelcomeHeader(),
                    Padding(
                      padding: const EdgeInsets.all(AppSizes.xxl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: WelcomeDimens.bodyGap,
                        children: [
                          Text(
                            WelcomeStrings.intro,
                            style: TextStyle(
                              color: colors.textSecondary,
                              fontSize: WelcomeDimens.introFontSize,
                              height: WelcomeDimens.introLineHeight,
                            ),
                          ),
                          const WelcomeFeatureCard(),
                          const Padding(
                            padding: EdgeInsets.only(top: AppSizes.xs),
                            child: WelcomeNameField(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSizes.xxl, 0, AppSizes.xxl, AppSizes.xxl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: WelcomeDimens.footerGap,
                  children: [
                    const OnboardingStepIndicator(current: 1, total: 3, label: WelcomeStrings.step),
                    WelcomeNextButton(onPressed: controller.next),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
