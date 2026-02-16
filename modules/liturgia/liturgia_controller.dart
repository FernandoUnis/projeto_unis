import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/biblia_models.dart';
import '../../models/liturgia_models.dart';
import '../../services/biblia_service.dart';
import '../../services/liturgia_service.dart';

class LiturgiaController extends GetxController {
  LiturgiaController();

  final _carregando = false.obs;
  final _liturgia = Rxn<LiturgiaDiaria>();
  final _erro = Rxn<String>();
  final _textosCarregando = <String, bool>{}.obs;
  final _versiculosPorLeitura = <String, List<Versiculo>>{}.obs;
  final _dataSelecionada = Rx<DateTime>(DateTime.now());

  bool get carregando => _carregando.value;
  LiturgiaDiaria? get liturgia => _liturgia.value;
  String? get erro => _erro.value;
  DateTime get dataSelecionada => _dataSelecionada.value;

  bool isCarregandoTexto(String referencia) {
    return _textosCarregando[referencia] ?? false;
  }

  List<Versiculo>? getVersiculos(String referencia) {
    return _versiculosPorLeitura[referencia];
  }

  DateTime get data => dataSelecionada;

  String get dataFormatada {
    final dataAtual = data;
    final diasSemana = [
      'Domingo',
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado',
    ];
    final meses = [
      'janeiro',
      'fevereiro',
      'março',
      'abril',
      'maio',
      'junho',
      'julho',
      'agosto',
      'setembro',
      'outubro',
      'novembro',
      'dezembro',
    ];

    final diaSemana = diasSemana[dataAtual.weekday % 7];
    final dia = dataAtual.day;
    final mes = meses[dataAtual.month - 1];
    final ano = dataAtual.year;

    return '$diaSemana, $dia de $mes de $ano';
  }

  String get dataFormatadaCurta {
    final dataAtual = data;
    final dia = dataAtual.day.toString().padLeft(2, '0');
    final mes = dataAtual.month.toString().padLeft(2, '0');
    final ano = dataAtual.year;
    return '$dia/$mes/$ano';
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is DateTime) {
      _dataSelecionada.value = args;
    }
    _carregarLiturgia();
  }

  Future<void> _carregarLiturgia() async {
    try {
      _carregando.value = true;
      _erro.value = null;

      final liturgia = await LiturgiaService.carregarLiturgia(data);
      _liturgia.value = liturgia;

      if (liturgia == null) {
        _erro.value = 'Liturgia não encontrada para esta data';
      } else {
        // Carrega os textos das leituras automaticamente
        await _carregarTextosLeituras();
      }
    } catch (e) {
      _erro.value = 'Erro ao carregar liturgia: ${e.toString()}';
    } finally {
      _carregando.value = false;
    }
  }

  Future<void> _carregarTextosLeituras() async {
    final liturgia = _liturgia.value;
    if (liturgia == null) return;

    // Carrega textos de todas as leituras
    for (final leitura in liturgia.leituras) {
      if (leitura.texto == null || leitura.texto!.isEmpty) {
        await _carregarTextoLeitura(leitura.referencia);
      }
    }

    // Carrega o texto do salmo se não estiver carregado
    if (liturgia.salmo != null &&
        (liturgia.salmoTexto == null || liturgia.salmoTexto!.isEmpty)) {
      await _carregarTextoLeitura(liturgia.salmo!);
    }
  }

  Future<void> _carregarTextoLeitura(String referencia) async {
    try {
      _textosCarregando[referencia] = true;
      _textosCarregando.refresh();

      // Busca os versículos individuais
      final versiculos = await BibliaService.buscarVersiculosPorReferencia(
        referencia,
      );

      if (versiculos != null && versiculos.isNotEmpty) {
        _versiculosPorLeitura[referencia] = versiculos;

        // Concatena o texto para manter compatibilidade
        final texto = versiculos.map((v) => v.texto).join(' ');

        // Atualiza a liturgia com o texto carregado
        final liturgiaAtual = _liturgia.value;
        if (liturgiaAtual != null) {
          final leiturasAtualizadas = liturgiaAtual.leituras.map((leitura) {
            if (leitura.referencia == referencia) {
              return LeituraLiturgica(
                referencia: leitura.referencia,
                titulo: leitura.titulo,
                texto: texto,
              );
            }
            return leitura;
          }).toList();

          // Verifica se é o salmo
          String? salmoTexto = liturgiaAtual.salmoTexto;
          if (liturgiaAtual.salmo == referencia) {
            salmoTexto = texto;
          }

          _liturgia.value = LiturgiaDiaria(
            data: liturgiaAtual.data,
            corLiturgica: liturgiaAtual.corLiturgica,
            tempoLiturgico: liturgiaAtual.tempoLiturgico,
            solenidade: liturgiaAtual.solenidade,
            festa: liturgiaAtual.festa,
            memoria: liturgiaAtual.memoria,
            leituras: leiturasAtualizadas,
            salmo: liturgiaAtual.salmo,
            salmoTexto: salmoTexto,
            salmoRefrao: liturgiaAtual.salmoRefrao,
            salmoRefraoReferencia: liturgiaAtual.salmoRefraoReferencia,
            aclamacao: liturgiaAtual.aclamacao,
            aclamacaoRefrao: liturgiaAtual.aclamacaoRefrao,
            oracao: liturgiaAtual.oracao,
            santoDoDia: liturgiaAtual.santoDoDia,
          );
        }
      }
    } catch (e) {
      // Ignora erros silenciosamente
    } finally {
      _textosCarregando[referencia] = false;
      _textosCarregando.refresh();
    }
  }

  Future<void> recarregar() async {
    await _carregarLiturgia();
  }

  Future<void> carregarTextoLeitura(String referencia) async {
    await _carregarTextoLeitura(referencia);
  }

  Color getCorLiturgica() {
    final cor = _liturgia.value?.corLiturgica?.toLowerCase();
    switch (cor) {
      case 'verde':
        return const Color(0xFF4CAF50);
      case 'roxo':
        return const Color(0xFF9C27B0);
      case 'vermelho':
        return const Color(0xFFF44336);
      case 'branco':
        return const Color(0xFFFFFFFF);
      case 'rosa':
        return const Color(0xFFE91E63);
      default:
        return const Color(0xFF4CAF50);
    }
  }
}
