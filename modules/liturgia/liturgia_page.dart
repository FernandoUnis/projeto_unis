import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/scaffold/app_scaffold.dart';
import '../../core/widgets/scaffold/default_app_bar.dart';
import '../../models/liturgia_models.dart';
import 'liturgia_controller.dart';

class LiturgiaPage extends GetView<LiturgiaController> {
  const LiturgiaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isVisibleAppBar: true,
      appBar: const DefaultAppBar(title: Text('LITURGIA DIÁRIA')),
      body: Obx(() {
        if (controller.carregando) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Carregando liturgia...', style: AppTextStyles.bodyMedium),
              ],
            ),
          );
        }

        if (controller.erro != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(controller.erro!, style: AppTextStyles.bodyLarge),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.recarregar,
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
        }

        final liturgia = controller.liturgia;
        if (liturgia == null) {
          return const Center(child: Text('Nenhuma liturgia encontrada'));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Cabeçalho com data e cor
            _buildHeader(liturgia),
            const SizedBox(height: 24),

            // Celebração do dia
            if (liturgia.nomeCelebracao != null) ...[
              _buildCelebracao(liturgia),
              const SizedBox(height: 24),
            ],

            // Leituras
            if (liturgia.leituras.isNotEmpty) ...[
              _buildLeituras(liturgia),
              const SizedBox(height: 24),
            ],

            // Aclamação
            if (liturgia.aclamacao != null ||
                liturgia.aclamacaoRefrao != null) ...[
              _buildAclamacao(liturgia),
              const SizedBox(height: 24),
            ],

            // Evangelho
            if (liturgia.evangelho != null) ...[
              Text(
                'EVANGELHO',
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildLeituraCard(liturgia.evangelho!),
              const SizedBox(height: 24),
            ],

            // Oração do Dia
            if (liturgia.oracao != null) ...[
              _buildOracao(liturgia),
              const SizedBox(height: 24),
            ],

            // Santo do dia
            if (liturgia.santoDoDia != null) ...[
              _buildSantoDoDia(liturgia),
              const SizedBox(height: 24),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildHeader(LiturgiaDiaria liturgia) {
    final corLiturgica = controller.getCorLiturgica();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: corLiturgica.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: corLiturgica.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.dataFormatadaCurta.toUpperCase(),
                style: AppTextStyles.labelLarge.copyWith(
                  color: corLiturgica,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: corLiturgica,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  (liturgia.corLiturgica ?? '').toUpperCase(),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            controller.dataFormatada,
            style: AppTextStyles.headlineSmallBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCelebracao(LiturgiaDiaria liturgia) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.celebration, color: AppColors.primaryColor, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  liturgia.tipoCelebracao?.toUpperCase() ?? '',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  liturgia.nomeCelebracao!,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeituras(LiturgiaDiaria liturgia) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LEITURAS',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ...liturgia.leituras.asMap().entries.map((entry) {
          final index = entry.key;
          final leitura = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < liturgia.leituras.length - 1 ? 16 : 0,
            ),
            child: _buildLeituraCard(leitura),
          );
        }),
      ],
    );
  }

  Widget _buildLeituraCard(LeituraLiturgica leitura) {
    final isCarregando = controller.isCarregandoTexto(leitura.referencia);
    final temTexto = leitura.texto != null && leitura.texto!.isNotEmpty;
    final versiculos = controller.getVersiculos(leitura.referencia);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutralLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutralLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  leitura.titulo.toUpperCase(),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              if (isCarregando)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (leitura.livro != null) ...[
            Text(
              leitura.livro!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 4),
          ],
          Text(
            leitura.referencia,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (leitura.subtitulo != null && leitura.subtitulo!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              leitura.subtitulo!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
          if (leitura.titulo.toLowerCase().contains('salmo'))
            _buildSalmoRefrao(),
          if (versiculos != null && versiculos.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.backgroundDefault,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...versiculos.map((versiculo) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _buildVersiculoText(
                        versiculo.texto,
                        versiculo.numero,
                      ),
                    );
                  }),
                  if (leitura.fechamento != null &&
                      leitura.fechamento!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      leitura.fechamento!,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.primaryColor,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ],
              ),
            ),
          ] else if (temTexto) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.backgroundDefault,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                leitura.texto!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ] else if (!isCarregando) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () =>
                  controller.carregarTextoLeitura(leitura.referencia),
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Carregar texto'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSalmoRefrao() {
    final liturgia = controller.liturgia;
    if (liturgia?.salmoRefrao != null && liturgia!.salmoRefrao!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.primaryColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (liturgia.salmoRefraoReferencia != null) ...[
                  Text(
                    liturgia.salmoRefraoReferencia!,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'R. ',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        liturgia.salmoRefrao!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          height: 1.6,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
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
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: texto,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAclamacao(LiturgiaDiaria liturgia) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF9C27B0).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.music_note, color: Color(0xFF9C27B0), size: 24),
              const SizedBox(width: 12),
              Text(
                'ACLAMAÇÃO AO EVANGELHO',
                style: AppTextStyles.labelSmall.copyWith(
                  color: const Color(0xFF9C27B0),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (liturgia.aclamacaoRefrao != null &&
              liturgia.aclamacaoRefrao!.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Text(
                    'R. ',
                    style: TextStyle(
                      color: Color(0xFF9C27B0),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      liturgia.aclamacaoRefrao!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (liturgia.aclamacao != null && liturgia.aclamacao!.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Text(
                    'V. ',
                    style: TextStyle(
                      color: Color(0xFF9C27B0),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      liturgia.aclamacao!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOracao(LiturgiaDiaria liturgia) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neutralLight, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.favorite, color: AppColors.primaryColor, size: 24),
              const SizedBox(width: 12),
              Text(
                'ORAÇÃO DO DIA',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            liturgia.oracao!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              height: 1.6,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildSantoDoDia(LiturgiaDiaria liturgia) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neutralLight, width: 1),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primaryLight,
            child: Icon(Icons.person, color: AppColors.primaryColor, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SANTO DO DIA',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  liturgia.santoDoDia!,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
