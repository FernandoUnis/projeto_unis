import 'dart:convert';

import 'package:flutter/services.dart';

import '../../models/liturgia_models.dart';

/// Interface do repositório de Liturgia
abstract class LiturgiaRepository {
  /// Carrega o calendário litúrgico completo
  Future<CalendarioLiturgico> carregarCalendario();

  /// Carrega a liturgia de uma data específica
  Future<LiturgiaDiaria?> carregarLiturgia(DateTime data);

  /// Verifica se o calendário já está em cache
  bool get temCache;

  /// Retorna o calendário do cache (se existir)
  CalendarioLiturgico? get calendarioCache;

  /// Limpa o cache
  void limparCache();
}

/// Implementação do repositório que acessa o arquivo JSON local
class LiturgiaRepositoryImpl implements LiturgiaRepository {
  static const String _caminhoJson = 'assets/data/calendario_liturgico.json';

  CalendarioLiturgico? _calendarioCache;
  bool _carregando = false;

  @override
  Future<CalendarioLiturgico> carregarCalendario() async {
    // Retorna do cache se já estiver carregado
    if (_calendarioCache != null) {
      return _calendarioCache!;
    }

    // Aguarda se já estiver carregando
    if (_carregando) {
      while (_carregando) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      if (_calendarioCache != null) {
        return _calendarioCache!;
      }
      throw Exception('Erro ao carregar o calendário: timeout');
    }

    _carregando = true;
    try {
      // Carrega o arquivo JSON
      final String jsonString = await rootBundle.loadString(_caminhoJson);

      // Decodifica o JSON
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Converte para o modelo CalendarioLiturgico
      _calendarioCache = CalendarioLiturgico.fromJson(jsonData);

      return _calendarioCache!;
    } catch (e) {
      throw Exception('Erro ao carregar o calendário litúrgico: $e');
    } finally {
      _carregando = false;
    }
  }

  @override
  Future<LiturgiaDiaria?> carregarLiturgia(DateTime data) async {
    final calendario = await carregarCalendario();
    return calendario.getLiturgia(data);
  }

  @override
  bool get temCache => _calendarioCache != null;

  @override
  void limparCache() {
    _calendarioCache = null;
  }

  /// Retorna o calendário do cache (se existir)
  @override
  CalendarioLiturgico? get calendarioCache => _calendarioCache;
}
