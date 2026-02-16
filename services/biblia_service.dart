import 'package:get/get.dart';

import '../core/repositories/biblia_repository.dart';
import '../core/services/settings_service.dart';
import '../core/utils/referencia_biblica_parser.dart';
import '../models/biblia_models.dart';

/// Serviço que gerencia o acesso à Bíblia usando o repositório
class BibliaService {
  static BibliaRepository? _repository;
  static Biblia? _biblia;
  static bool _carregando = false;

  /// Inicializa o repositório (pode ser injetado para testes)
  static void inicializar(BibliaRepository? repository) {
    _repository = repository ?? BibliaRepositoryImpl();
  }

  /// Obtém a instância do repositório
  static BibliaRepository get _repo {
    _repository ??= BibliaRepositoryImpl();
    return _repository!;
  }

  /// Carrega a Bíblia usando o repositório
  static Future<Biblia> carregarBiblia() async {
    final settingsService = Get.find<SettingsService>();
    final translation = settingsService.selectedBibleTranslation.value;
    final path = _getTranslationPath(translation);

    // Retorna do cache se já estiver carregado
    if (_biblia != null &&
        _repo.temCache &&
        _repo.bibliaCache?.versao == translation) {
      return _biblia!;
    }

    // Verifica se o repositório tem cache compatível
    if (_repo.temCache && _repo.bibliaCache?.versao == translation) {
      _biblia = _repo.bibliaCache;
      if (_biblia != null) {
        return _biblia!;
      }
    }

    if (_carregando) {
      // Aguardar se já estiver carregando
      while (_carregando) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      if (_biblia != null && _biblia?.versao == translation) {
        return _biblia!;
      }
      // Se era outra tradução, continua para carregar a nova
    }

    _carregando = true;
    try {
      // Usa o repositório para carregar
      _biblia = await _repo.carregarBiblia(caminhoJson: path);
      return _biblia!;
    } catch (e) {
      throw Exception('Erro ao carregar a Bíblia ($translation): $e');
    } finally {
      _carregando = false;
    }
  }

  static String _getTranslationPath(String translation) {
    switch (translation) {
      case 'Figueiredo':
        return 'assets/data/biblia_figueiredo.json';
      case 'Ave Maria':
      default:
        return 'assets/data/biblia_ave_maria_fatima.json';
    }
  }

  /// Retorna a Bíblia do cache (se existir)
  static Biblia? get biblia => _biblia;

  /// Limpa o cache do serviço e do repositório
  static void limparCache() {
    _biblia = null;
    _repo.limparCache();
  }

  /// Busca versículos por referência bíblica (ex: "Is 40,1-11")
  /// Retorna null se não encontrar
  static Future<List<Versiculo>?> buscarVersiculosPorReferencia(
    String referencia,
  ) async {
    try {
      final biblia = await carregarBiblia();
      return ReferenciaBiblicaParser.buscarVersiculosPorString(
        biblia,
        referencia,
      );
    } catch (e) {
      return null;
    }
  }

  /// Busca versículos por referência bíblica (versão síncrona, requer Bíblia já carregada)
  /// Retorna null se não encontrar ou se a Bíblia não estiver carregada
  static List<Versiculo>? buscarVersiculosPorReferenciaSync(String referencia) {
    final biblia = _biblia;
    if (biblia == null) return null;
    return ReferenciaBiblicaParser.buscarVersiculosPorString(
      biblia,
      referencia,
    );
  }

  /// Busca um livro pela abreviação
  static Future<Livro?> buscarLivroPorAbreviacao(String abreviacao) async {
    try {
      final biblia = await carregarBiblia();
      return ReferenciaBiblicaParser.buscarLivroPorAbreviacao(
        biblia,
        abreviacao,
      );
    } catch (e) {
      return null;
    }
  }
}
