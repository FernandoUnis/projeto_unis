import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/dependencies/app_pages.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/scaffold/app_scaffold.dart';
import '../../core/widgets/scaffold/default_app_bar.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const DefaultAppBar(
        title: Text('Olá, seja bem-vindo!'),
        shadowColor: AppColors.backgroundDefault,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.carregando) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Carregando...', style: AppTextStyles.bodyMedium),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // Feature Cards (Tools)
              _buildFeatureCards(),

              const SizedBox(height: 32),

              // Bible Version Selection
              _buildBibleVersionSelector(),

              const SizedBox(height: 32),

              // Salmo do Dia
              _buildSalmoCard(),

              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSalmoCard() {
    final liturgia = controller.liturgiaHoje;
    final salmoRef = liturgia?.salmo;
    final salmoTexto = controller.salmoTexto;
    final carregandoSalmo = controller.carregandoSalmo;

    if (salmoRef == null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundDefault,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.accentColor.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.music_note_outlined,
                  color: AppColors.accentColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('SALMO DO DIA', style: AppTextStyles.labelSmall),
                    const SizedBox(height: 4),
                    Text(
                      salmoRef,
                      style: AppTextStyles.headlineSmallBold.copyWith(
                        color: AppColors.neutralBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (carregandoSalmo) ...[
            const SizedBox(height: 20),
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ] else if (salmoTexto != null && salmoTexto.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.neutralLight, width: 1),
              ),
              child: Text(
                salmoTexto,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.neutralBlack,
                  height: 1.7,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => Get.toNamed(AppPages.livros),
                icon: const Icon(Icons.menu_book, size: 18),
                label: const Text(
                  'Ler na Bíblia',
                  style: AppTextStyles.labelLarge,
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.accentColor,
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 20),
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.neutralDark,
                      size: 32,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Salmo não disponível',
                      style: TextStyle(
                        color: AppColors.neutralDark,
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFeatureCards() {
    return Row(
      spacing: 12,
      children: [
        Expanded(
          child: _buildFeatureCard(
            icon: Icons.menu_book_rounded,
            label: 'BÍBLIA',
            color: AppColors.primaryColor,
            onTap: () => Get.toNamed(AppPages.livros),
          ),
        ),
        Expanded(
          child: _buildFeatureCard(
            icon: Icons.calendar_month_rounded,
            label: 'LITURGIA',
            color: const Color(0xFF9C27B0),
            onTap: () => Get.toNamed(AppPages.liturgia),
          ),
        ),
        Expanded(
          child: _buildFeatureCard(
            icon: Icons.menu_book_rounded,
            label: 'CATEQUESE',
            color: const Color(0xFF4CAF50),
            onTap: () => Get.toNamed(AppPages.catequese),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.backgroundDefault,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(3, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.neutralBlack,
                letterSpacing: 0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBibleVersionSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('VERSÃO DA BÍBLIA', style: AppTextStyles.labelSmall),
        const SizedBox(height: 12),
        Obx(() {
          final selected =
              controller.settingsService.selectedBibleTranslation.value;
          return Row(
            children: [
              _buildVersionChip('Ave Maria', selected == 'Ave Maria'),
              const SizedBox(width: 12),
              _buildVersionChip('Figueiredo', selected == 'Figueiredo'),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildVersionChip(String label, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          controller.settingsService.setBibleTranslation(label);
          Get.toNamed(AppPages.livros);
          Get.snackbar(
            'Bíblia Atualizada',
            'A tradução foi alterada para $label',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.primaryColor.withValues(alpha: 0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryColor
                  : AppColors.neutralLight,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelLarge.copyWith(
              color: isSelected ? Colors.white : AppColors.neutralBlack,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
