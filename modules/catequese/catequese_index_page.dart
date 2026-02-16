import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/scaffold/app_scaffold.dart';
import '../../core/widgets/scaffold/default_app_bar.dart';
import '../../models/catechism_models.dart';
import 'catequese_controller.dart';

class CatequeseIndexPage extends GetView<CatequeseController> {
  const CatequeseIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isVisibleAppBar: true,
      appBar: DefaultAppBar(title: Text('CATECISMO')),
      body: Obx(() {
        if (controller.carregando) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.erro != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: AppColors.alertError, size: 48),
                Text(
                  'Erro ao carregar: ${controller.erro}',
                  style: AppTextStyles.bodyMedium,
                ),
                ElevatedButton(
                  onPressed: controller.recarregar,
                  child: const Text('Recarregar'),
                ),
              ],
            ),
          );
        }

        final catecismo = controller.catecismo!;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (controller.lastParagraphNumber > 0)
              Card(
                color: AppColors.primaryLight,
                child: ListTile(
                  leading: Icon(Icons.bookmark, color: AppColors.primaryColor),
                  title: Text(
                    'Continuar Lendo',
                    style: AppTextStyles.titleMedium,
                  ),
                  subtitle: Text(
                    'Parágrafo ${controller.lastParagraphNumber}',
                    style: AppTextStyles.bodySmall,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // This is a bit complex since paragraphs are in chapters
                    // We need to find the chapter containing the paragraph
                    _navigateToParagraph(controller.lastParagraphNumber);
                  },
                ),
              ),
            const SizedBox(height: 16),
            ...catecismo.parts.map((part) => _buildPart(part)),
          ],
        );
      }),
    );
  }

  Widget _buildPart(CatechismPart part) {
    return ExpansionTile(
      title: Text(
        part.title,
        style: AppTextStyles.titleMedium.copyWith(
          color: AppColors.primaryColor,
        ),
      ),
      children: [
        ...part.sections.map((section) => _buildSection(section)),
        ...part.chapters.map((chapter) => _buildChapter(chapter)),
      ],
    );
  }

  Widget _buildSection(CatechismSection section) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: ExpansionTile(
        title: Text(
          section.title,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        children: section.chapters
            .map((chapter) => _buildChapter(chapter))
            .toList(),
      ),
    );
  }

  Widget _buildChapter(CatechismChapter chapter) {
    final hasContent = chapter.paragraphs.isNotEmpty;
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 32.0, right: 16.0),
      title: Text(
        chapter.title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: hasContent ? AppColors.textPrimary : AppColors.textSecondary,
        ),
      ),
      trailing: Text(
        '${chapter.paragraphs.length} §',
        style: AppTextStyles.labelSmall.copyWith(
          color: hasContent ? AppColors.textPrimary : AppColors.textSecondary,
        ),
      ),
      onTap: hasContent
          ? () => Get.toNamed('/catequese/leitura', arguments: chapter)
          : null,
    );
  }

  void _navigateToParagraph(int paragraphNumber) {
    if (controller.catecismo == null) return;

    CatechismChapter? targetChapter;
    for (var part in controller.catecismo!.parts) {
      for (var section in part.sections) {
        for (var chapter in section.chapters) {
          if (chapter.paragraphs.any((p) => p.number == paragraphNumber)) {
            targetChapter = chapter;
            break;
          }
        }
        if (targetChapter != null) break;
      }
      if (targetChapter != null) break;
      for (var chapter in part.chapters) {
        if (chapter.paragraphs.any((p) => p.number == paragraphNumber)) {
          targetChapter = chapter;
          break;
        }
      }
      if (targetChapter != null) break;
    }

    if (targetChapter != null) {
      Get.toNamed(
        '/catequese/leitura',
        arguments: {
          'chapter': targetChapter,
          'initialParagraph': paragraphNumber,
        },
      );
    }
  }
}
