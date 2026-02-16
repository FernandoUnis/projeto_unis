import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lumen_caeli/core/services/settings_service.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/scaffold/app_scaffold.dart';
import '../../core/widgets/scaffold/default_app_bar.dart';
import '../../models/biblia_models.dart';
import 'livros_controller.dart';

class LivrosPage extends GetView<LivrosController> {
  const LivrosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.carregando) {
        return AppScaffold(
          isVisibleAppBar: true,
          appBar: const DefaultAppBar(title: Text('BÍBLIA')),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Carregando a Bíblia...', style: AppTextStyles.bodyMedium),
              ],
            ),
          ),
        );
      }

      if (controller.erro != null) {
        return AppScaffold(
          isVisibleAppBar: true,
          appBar: const DefaultAppBar(title: Text('BÍBLIA')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.alertError,
                ),
                const SizedBox(height: 16),
                Text('Erro: ${controller.erro}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.recarregar,
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        );
      }

      if (controller.biblia == null) {
        return AppScaffold(
          isVisibleAppBar: true,
          appBar: const DefaultAppBar(title: Text('BÍBLIA')),
          body: const Center(child: Text('Nenhum dado disponível')),
        );
      }

      return DefaultTabController(
        length: 2,
        child: AppScaffold(
          isVisibleAppBar: true,
          appBar: DefaultAppBar(
            title: const Text('BÍBLIA'),
            // controller.isSearching
            //     ? TextField(
            //         autofocus: true,
            //         style: AppTextStyles.bodyLarge.copyWith(
            //           color: AppColors.white,
            //         ),
            //         cursorColor: AppColors.white,
            //         decoration: InputDecoration(
            //           hintText: 'Pesquisar livro...',
            //           hintStyle: AppTextStyles.bodyLarge.copyWith(
            //             color: AppColors.white70,
            //           ),
            //           border: InputBorder.none,
            //         ),
            //         onChanged: controller.updateSearchQuery,
            //       )
            //     : const Text('BÍBLIA'),
            // actions: [
            //   IconButton(
            //     icon: Icon(controller.isSearching ? Icons.close : Icons.search),
            //     onPressed: controller.toggleSearch,
            //   ),
            // ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(
                110,
              ), // TabBar (48) + Selector (50) + padding
              child: Column(
                children: [
                  _buildVersionSelector(),
                  const TabBar(
                    labelColor: AppColors.white,
                    unselectedLabelColor: AppColors.white70,
                    indicatorColor: AppColors.white,
                    tabs: [
                      Tab(text: 'Antigo Testamento'),
                      Tab(text: 'Novo Testamento'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          persistentFooterAlignment: AlignmentDirectional.center,
          persistentFooterButtons: controller.lastReading != null
              ? [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: controller.navegarParaUltimaLeitura,
                          icon: const Icon(Icons.bookmark),
                          label: Text(
                            'Continuar Lendo: ${controller.lastReading!['libro']} ${controller.lastReading!['capitulo']}${controller.lastReading!['versiculo'] != null ? ':${controller.lastReading!['versiculo']}' : ''}',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: controller.limparUltimaLeitura,
                        icon: const Icon(Icons.close),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.alertError,
                          foregroundColor: AppColors.white,
                          shape: const CircleBorder(),
                        ),
                      ),
                    ],
                  ),
                ]
              : null,
          body: TabBarView(
            children: [
              _buildTestamento(
                context,
                controller.biblia!.antigoTestamento,
                'Antigo Testamento',
              ),
              _buildTestamento(
                context,
                controller.biblia!.novoTestamento,
                'Novo Testamento',
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTestamento(
    BuildContext context,
    TestamentoBase testamento,
    String titulo,
  ) {
    final categorias = controller.getFilteredCategorias(testamento);

    if (categorias.isEmpty) {
      return const Center(child: Text('Nenhum livro encontrado'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        final categoria = categorias[index];
        final livros = categoria.livros;

        return ExpansionTile(
          initiallyExpanded: controller.isSearching,
          leading: Icon(
            _getIconForCategoria(categoria.nome),
            color: AppColors.primaryColor,
          ),
          title: Text(
            _getNomeCategoria(categoria.nome),
            style: AppTextStyles.titleMedium,
          ),
          subtitle: Text(
            '${livros.length} livros',
            style: AppTextStyles.bodySmall,
          ),
          children: livros.map((livro) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  livro.abreviacao.isNotEmpty
                      ? livro.abreviacao
                      : _getIniciais(livro.nome),
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.black,
                  ),
                ),
              ),
              title: Text(livro.nome, style: AppTextStyles.bodyLarge),
              subtitle: Text(
                '${livro.capitulos.length} capítulos',
                style: AppTextStyles.bodySmall,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => controller.navegarParaCapitulos(livro),
            );
          }).toList(),
        );
      },
    );
  }

  IconData _getIconForCategoria(String categoria) {
    switch (categoria) {
      case 'pentateuco':
        return Icons.menu_book;
      case 'historicos':
        return Icons.history;
      case 'poeticos':
        return Icons.music_note;
      case 'profeticos':
        return Icons.visibility;
      case 'evangelhos':
        return Icons.book;
      case 'historico':
        return Icons.timeline;
      case 'cartasPaulinas':
        return Icons.mail;
      case 'cartasCatolicas':
        return Icons.email;
      case 'apocalipse':
        return Icons.wb_sunny;
      default:
        return Icons.book;
    }
  }

  String _getNomeCategoria(String categoria) {
    switch (categoria) {
      case 'pentateuco':
        return 'Pentateuco';
      case 'historicos':
        return 'Livros Históricos';
      case 'poeticos':
        return 'Livros Poéticos';
      case 'profeticos':
        return 'Livros Proféticos';
      case 'evangelhos':
        return 'Evangelhos';
      case 'historico':
        return 'Histórico';
      case 'cartasPaulinas':
        return 'Cartas Paulinas';
      case 'cartasCatolicas':
        return 'Cartas Católicas';
      case 'apocalipse':
        return 'Apocalipse';
      default:
        return categoria;
    }
  }

  String _getIniciais(String nome) {
    if (nome.isEmpty) return '';
    final words = nome.trim().split(RegExp(r'\s+'));
    if (words.length == 1) return words[0].substring(0, 1).toUpperCase();
    return words
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join('')
        .substring(0, 2);
  }

  Widget _buildVersionSelector() {
    final settingsService = Get.find<SettingsService>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Obx(() {
        final selected = settingsService.selectedBibleTranslation.value;
        return Row(
          children: [
            _buildVersionChip(
              'Ave Maria',
              selected == 'Ave Maria',
              settingsService,
            ),
            const SizedBox(width: 12),
            _buildVersionChip(
              'Figueiredo',
              selected == 'Figueiredo',
              settingsService,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildVersionChip(
    String label,
    bool isSelected,
    SettingsService settingsService,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => settingsService.setBibleTranslation(label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.white.withValues(alpha: isSelected ? 1 : 0.5),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelMedium.copyWith(
              color: isSelected ? AppColors.primaryColor : AppColors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
