import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../index.dart';

// 课程大纲
class CourseOutlineWidget extends StatelessWidget {
  final CourseModel course;
  final String? chapterId;
  final Function(String suri)? onTap;
  const CourseOutlineWidget({
    super.key,
    required this.course,
    required this.chapterId,
    this.onTap,
  });

  // 显示课程大纲
  Widget _buildOutline() {
    return ListView.builder(
      itemCount: course.chapters?.length,
      itemBuilder: (context, index) {
        ChapterModel? chapter = course.chapters?.elementAt(index);
        return chapter == null
            ? const SizedBox.shrink()
            : ExpansionTile(
                title: Text(chapter.title ?? ""),
                leading:
                    Icon(Icons.folder_outlined, color: AppColors.secondary),
                // backgroundColor: Colors.white,
                initiallyExpanded: chapter.id == chapterId, // 是否默认展开
                children: List<Widget>.generate(chapter.sections?.length ?? 0,
                    (index) {
                  SectionModel? section = chapter.sections?.elementAt(index);
                  return section == null
                      ? const SizedBox.shrink()
                      : ListTile(
                          leading: Icon(Icons.play_circle_filled,
                              color: AppColors.secondary),
                          title: Text(section.title ?? ""),
                          trailing: TextWidget.body1(
                            section.minutes == 0
                                ? ""
                                : "${section.minutes} ${LocaleKeys.timeMinutes.tr}",
                            color: AppColors.secondary.withOpacity(0.5),
                          ),
                          // 选中章节
                          onTap:
                              (section.minutes == 0 && section.isDocOk == false)
                                  ? null
                                  : () {
                                      if (!UserService.to.isLogin) {
                                        Get.toNamed(RouteNames.systemLogin);
                                      } else {
                                        if (onTap != null) {
                                          onTap!(section.uri!);
                                        }
                                      }
                                      // await controller.onFilterSection(
                                      //   chapter.id!,
                                      //   section.id!,
                                      // );
                                      // Get.back();
                                    },
                          // 先关闭再去新页面 这样不会 同控制器冲突
                          // onTap: () => Get.offAndToNamed(
                          //   RouteNames.courseCourseLearn,
                          //   parameters: {
                          //     "uri": controller.uri,
                          //     "cid": chapter.id ?? "",
                          //     "sid": section.id ?? "",
                          //   },
                          // ),
                        );
                }),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildOutline();
  }
}
