import 'dart:convert';

import 'package:flutter/services.dart';

import '../../models/biblia_models.dart';

/// Interface do repositório de Bíblia
abstract class BibliaRepository {
  /// Carrega a Bíblia completa
  Future<Biblia> carregarBiblia({String? caminhoJson});

  /// Verifica se a Bíblia já está em cache
  bool get temCache;

  /// Retorna a Bíblia do cache (se existir)
  Biblia? get bibliaCache;

  /// Limpa o cache
  void limparCache();
}

/// Implementação do repositório que acessa o arquivo JSON
class BibliaRepositoryImpl implements BibliaRepository {
  static const String defaultCaminhoJson =
      'assets/data/biblia_ave_maria_fatima.json';

  Biblia? _bibliaCache;
  String? _caminhoCarregado;
  bool _carregando = false;

  @override
  Future<Biblia> carregarBiblia({String? caminhoJson}) async {
    final path = caminhoJson ?? defaultCaminhoJson;

    // Retorna do cache se já estiver carregado o mesmo arquivo
    if (_bibliaCache != null && _caminhoCarregado == path) {
      return _bibliaCache!;
    }

    // Aguarda se já estiver carregando
    if (_carregando) {
      while (_carregando) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      if (_bibliaCache != null && _caminhoCarregado == path) {
        return _bibliaCache!;
      }
      // Se terminou de carregar mas era outro arquivo, continuamos para carregar o novo
    }

    _carregando = true;
    try {
      // Carrega o arquivo JSON
      final String jsonString = await rootBundle.loadString(path);

      // Decodifica o JSON
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Converte para o modelo Biblia
      _bibliaCache = Biblia.fromJson(jsonData);
      _caminhoCarregado = path;

      return _bibliaCache!;
    } catch (e) {
      throw Exception('Erro ao carregar a Bíblia ($path): $e');
    } finally {
      _carregando = false;
    }
  }

  @override
  bool get temCache => _bibliaCache != null;

  @override
  void limparCache() {
    _bibliaCache = null;
    _caminhoCarregado = null;
  }

  /// Retorna a Bíblia do cache (se existir)
  @override
  Biblia? get bibliaCache => _bibliaCache;
}
