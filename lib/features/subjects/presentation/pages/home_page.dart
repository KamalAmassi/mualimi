import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../controllers/home_controller.dart';
import '../widgets/continue_lesson_card.dart';
import '../widgets/home_dimens.dart';
import '../widgets/home_hero.dart';
import '../widgets/subjects_grid_row.dart';
import '../widgets/subjects_section_header.dart';

/// Shell tab 1.
class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.background,
      body: Obx(() {
        final lesson = controller.continueLesson.value;
        final subjects = controller.subjects.toList();
        return CustomScrollView(slivers: [
          SliverToBoxAdapter(
            child: HomeHero(
              greeting: controller.greeting,
              name: controller.student.value.name,
              gradeLabel: controller.gradeLabel,
              online: controller.online.value,
              bottomPadding: lesson == null ? HomeDimens.heroBottomNoCard : HomeDimens.heroBottom,
            ),
          ),
          if (lesson != null)
            SliverToBoxAdapter(
              child: Stack(children: [
                PositionedDirectional(
                  top: 0,
                  start: 0,
                  end: 0,
                  height: HomeDimens.cardOverlap,
                  child: ColoredBox(color: c.hero),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: HomeDimens.pageGutter),
                  child: ContinueLessonCard(lesson: lesson, onTap: controller.openContinueLesson),
                ),
              ]),
            ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(HomeDimens.pageGutter, HomeDimens.sectionTop,
                HomeDimens.pageGutter, HomeDimens.gridGap),
            sliver: SliverToBoxAdapter(child: SubjectsSectionHeader(count: subjects.length)),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
                HomeDimens.pageGutter, 0, HomeDimens.pageGutter, HomeDimens.pageGutter),
            sliver: SliverList.builder(
              itemCount: (subjects.length + 1) ~/ 2,
              itemBuilder: (context, row) => SubjectsGridRow(
                subjects: subjects.skip(row * 2).take(2).toList(),
                isFirst: row == 0,
                onOpen: controller.open,
              ),
            ),
          ),
        ]);
      }),
    );
  }
}
