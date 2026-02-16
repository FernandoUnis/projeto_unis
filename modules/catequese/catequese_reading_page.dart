import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/scaffold/app_scaffold.dart';
import '../../core/widgets/scaffold/default_app_bar.dart';
import 'catequese_controller.dart';

class CatequeseReadingPage extends GetView<CatequeseController> {
  const CatequeseReadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initializing logic should theoretically be in controller,
    // but we can call it here once when the widget is inserted.
    // Using a Scheduler or simple check to avoid repeated calls.
    controller.initReading(Get.arguments);

    return Obx(() {
      final chapter = controller.chapter;

      if (chapter == null) {
        return const AppScaffold(
          isVisibleAppBar: true,
          appBar: DefaultAppBar(title: Text('Erro')),
          body: Center(
            child: Text(
              'Capítulo não encontrado',
              style: AppTextStyles.bodyMedium,
            ),
          ),
        );
      }

      return AppScaffold(
        isVisibleAppBar: true,
        appBar: DefaultAppBar(
          title: Text(chapter.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.format_size),
              onPressed: controller.toggleFontSettings,
            ),
          ],
        ),
        body: Column(
          children: [
            if (controller.showFontSettings)
              Container(
                padding: const EdgeInsets.all(16),
                color: AppColors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.text_fields, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Slider(
                            value: controller.fontSize,
                            min: 12,
                            max: 32,
                            activeColor: AppColors.primaryColor,
                            inactiveColor: AppColors.primaryLight,
                            onChanged: controller.updateFontSize,
                          ),
                        ),
                        Text(
                          '${controller.fontSize.toInt()}',
                          style: AppTextStyles.labelLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildFontButton('Sans Serif', 'OpenSans'),
                        _buildFontButton('Serif', 'Georgia'),
                      ],
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ScrollablePositionedList.builder(
                itemCount: chapter.paragraphs.length,
                itemScrollController: controller.itemScrollController,
                itemPositionsListener: controller.itemPositionsListener,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final p = chapter.paragraphs[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${p.number}',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: controller.fontSize * 0.7,
                                  fontFamily: controller.fontFamily,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                p.text,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  height: 1.5,
                                  fontSize: controller.fontSize,
                                  fontFamily: controller.fontFamily,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFontButton(String label, String family) {
    return Obx(() {
      final isSelected = controller.fontFamily == family;
      return FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => controller.updateFontFamily(family),
        selectedColor: AppColors.primaryLight,
        checkmarkColor: AppColors.primaryColor,
      );
    });
  }
}
