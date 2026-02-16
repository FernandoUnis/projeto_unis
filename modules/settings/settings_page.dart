import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_icon_gradiente.dart';
import '../../core/widgets/scaffold/app_scaffold.dart';
import '../../core/widgets/scaffold/default_app_bar.dart';
import 'settings_controller.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isVisibleAppBar: true,
      appBar: DefaultAppBar(title: Text('Configurações')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Seção de Fontes
          _buildSectionTitle('Escolha a Fonte'),
          const SizedBox(height: 12),
          _buildFontOptions(),
          const SizedBox(height: 32),

          // Seção de Paletas de Cores
          _buildSectionTitle('Escolha a Paleta de Cores'),
          const SizedBox(height: 12),
          _buildColorPalettes(),
          const SizedBox(height: 32),

          // Seção de Tradução da Bíblia
          _buildSectionTitle('Tradução da Bíblia'),
          const SizedBox(height: 12),
          _buildBibleTranslationOptions(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.titleLarge.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildFontOptions() {
    return Obx(() {
      final selectedIndex = controller.settingsService.selectedFontIndex.value;
      return Column(
        children: List.generate(controller.fonts.length, (index) {
          final font = controller.fonts[index];
          final isSelected = selectedIndex == index;

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(
                font.name,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontFamily: font.fontFamily,
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: isSelected
                  ? AppIconGradiente(Icons.check_circle)
                  : const Icon(Icons.circle_outlined),
              onTap: () => controller.selectFont(index),
            ),
          );
        }),
      );
    });
  }

  Widget _buildColorPalettes() {
    return Obx(() {
      final selectedIndex =
          controller.settingsService.selectedPaletteIndex.value;
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
        ),
        itemCount: controller.palettes.length,
        itemBuilder: (context, index) {
          final palette = controller.palettes[index];
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () => controller.selectPalette(index),
            child: Card(
              elevation: isSelected ? 4 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected ? palette.primaryColor : Colors.transparent,
                  width: 3,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Preview das cores
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildColorCircle(palette.primaryDark),
                      const SizedBox(width: 4),
                      _buildColorCircle(palette.primaryColor),
                      const SizedBox(width: 4),
                      _buildColorCircle(palette.primaryLight),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    palette.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? palette.primaryColor
                          : AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (isSelected)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: AppIconGradiente(Icons.check_circle, size: 20),
                    ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildColorCircle(Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.textSecondary.withOpacity(0.3)),
      ),
    );
  }

  Widget _buildBibleTranslationOptions() {
    return Obx(() {
      final selectedTranslation =
          controller.settingsService.selectedBibleTranslation.value;
      final translations = ['Ave Maria', 'Figueiredo'];

      return Column(
        children: translations.map((translation) {
          final isSelected = selectedTranslation == translation;

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(
                translation,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: isSelected
                  ? AppIconGradiente(Icons.check_circle)
                  : const Icon(Icons.circle_outlined),
              onTap: () {
                controller.selectBibleTranslation(translation);
                // Opcional: Avisar que a Bíblia será recarregada
                Get.snackbar(
                  'Bíblia Atualizada',
                  'A tradução foi alterada para $translation',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.primaryColor.withOpacity(0.8),
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                );
              },
            ),
          );
        }).toList(),
      );
    });
  }
}
