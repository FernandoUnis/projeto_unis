import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lumen_caeli/core/utils/size_util.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/scaffold/app_scaffold.dart';
import '../../core/widgets/scaffold/default_app_bar.dart';
import 'capitulos_controller.dart';

class CapitulosPage extends GetView<CapitulosController> {
  const CapitulosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isVisibleAppBar: true,
      appBar: DefaultAppBar(title: Text(controller.livro.nome.toUpperCase())),
      body: controller.livro.capitulos.isEmpty
          ? Center(
              child: Text(
                'Nenhum capítulo disponível',
                style: AppTextStyles.bodyMedium,
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.only(
                top: 8,
                left: 8,
                right: 8,
                bottom: calculateBottomNavigationBarHeight(context),
              ),
              itemCount: controller.livro.capitulos.length,
              itemBuilder: (context, index) {
                final capitulo = controller.livro.capitulos[index];
                final temVersiculos = capitulo.versiculos.isNotEmpty;

                return Card(
                  elevation: 2,
                  color: AppColors.cardBackground,

                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: temVersiculos
                          ? AppColors.primaryColor
                          : AppColors.neutralGray,
                      child: Text(
                        '${capitulo.numero}',
                        style: AppTextStyles.headlineSmallBold.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    title: Text(
                      'Capítulo ${capitulo.numero}',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: temVersiculos
                            ? AppColors.primaryColor
                            : AppColors.neutralDark,
                      ),
                    ),
                    subtitle: Text(
                      temVersiculos
                          ? '${capitulo.versiculos.length} versículos'
                          : 'Sem versículos disponíveis',
                      style: AppTextStyles.bodySmall,
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: temVersiculos ? null : AppColors.neutralGray,
                    ),
                    onTap: temVersiculos
                        ? () => controller.navegarParaVersiculos(capitulo)
                        : null,
                  ),
                );
              },
            ),
    );
  }
}
