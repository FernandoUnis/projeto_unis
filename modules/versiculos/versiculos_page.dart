import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/scaffold/app_scaffold.dart';
import '../../core/widgets/scaffold/default_app_bar.dart';
import 'versiculos_controller.dart';

class VersiculosPage extends GetView<VersiculosController> {
  const VersiculosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isVisibleAppBar: true,
      appBar: DefaultAppBar(
        title: Text(
          '${controller.livro.nome.toUpperCase()} ${controller.capitulo.numero}',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.format_size),
            onPressed: controller.toggleFontSettings,
          ),
        ],
      ),
      body: Obx(() {
        return Column(
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
              child: controller.capitulo.versiculos.isEmpty
                  ? const Center(child: Text('Nenhum versículo disponível'))
                  : NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        controller.onScrollNotification(notification);
                        return true;
                      },
                      child: Stack(
                        children: [
                          SafeArea(
                            child: ListView.builder(
                              controller: controller.scrollController,
                              padding: const EdgeInsets.all(16),
                              itemCount: controller.capitulo.versiculos.length,
                              itemBuilder: (context, index) {
                                final versiculo =
                                    controller.capitulo.versiculos[index];
                                return Padding(
                                  key: ValueKey('verse_$index'),
                                  padding: const EdgeInsets.all(4),
                                  child: _buildVersiculoText(
                                    versiculo.texto,
                                    versiculo.numero,
                                  ),
                                );
                              },
                            ),
                          ),
                          if (controller.showScrollIndicator)
                            Positioned(
                              top: 20,
                              right: 20,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.8,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'Versículo ${controller.currentVerse}',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFontButton(String label, String family) {
    final isSelected = controller.fontFamily == family;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => controller.updateFontFamily(family),
      selectedColor: AppColors.primaryLight,
      checkmarkColor: AppColors.primaryColor,
    );
  }

  Widget _buildVersiculoText(String texto, int numeroVersiculo) {
    if (texto.isEmpty) {
      return const SizedBox.shrink();
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$numeroVersiculo ',
            style: AppTextStyles.labelLarge.copyWith(
              fontSize: controller.fontSize + 4,
              fontFamily: controller.fontFamily,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          TextSpan(
            text: texto,
            style: AppTextStyles.bodyLarge.copyWith(
              fontSize: controller.fontSize,
              fontFamily: controller.fontFamily,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
