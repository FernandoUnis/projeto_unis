import '../core/repositories/liturgia_repository.dart';
import '../models/liturgia_models.dart';
import '../services/biblia_service.dart';

/// Serviço que gerencia o acesso ao calendário litúrgico usando o repositório
class LiturgiaService {
  static LiturgiaRepository? _repository;
  static CalendarioLiturgico? _calendario;
  static bool _carregando = false;

  /// Inicializa o repositório (pode ser injetado para testes)
  static void inicializar(LiturgiaRepository? repository) {
    _repository = repository ?? LiturgiaRepositoryImpl();
  }

  /// Obtém a instância do repositório
  static LiturgiaRepository get _repo {
    _repository ??= LiturgiaRepositoryImpl();
    return _repository!;
  }

  /// Carrega o calendário litúrgico usando o repositório
  static Future<CalendarioLiturgico> carregarCalendario() async {
    // Retorna do cache se já estiver carregado
    if (_calendario != null) {
      return _calendario!;
    }

    // Verifica se o repositório tem cache
    if (_repo.temCache) {
      _calendario = _repo.calendarioCache;
      if (_calendario != null) {
        return _calendario!;
      }
    }

    if (_carregando) {
      // Aguardar se já estiver carregando
      while (_carregando) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      if (_calendario != null) {
        return _calendario!;
      }
      throw Exception('Erro ao carregar o calendário: timeout');
    }

    _carregando = true;
    try {
      // Usa o repositório para carregar
      _calendario = await _repo.carregarCalendario();
      return _calendario!;
    } catch (e) {
      throw Exception('Erro ao carregar o calendário litúrgico: $e');
    } finally {
      _carregando = false;
    }
  }

  /// Carrega a liturgia de uma data específica
  static Future<LiturgiaDiaria?> carregarLiturgia(DateTime data) async {
    try {
      final calendario = await carregarCalendario();
      return calendario.getLiturgia(data);
    } catch (e) {
      return null;
    }
  }

  /// Retorna a liturgia de hoje
  static Future<LiturgiaDiaria?> get liturgiaHoje async {
    return await carregarLiturgia(DateTime.now());
  }

  /// Retorna o calendário do cache (se existir)
  static CalendarioLiturgico? get calendario => _calendario;

  /// Limpa o cache do serviço e do repositório
  static void limparCache() {
    _calendario = null;
    _repo.limparCache();
  }

  /// Busca o texto de uma leitura usando sua referência bíblica
  /// Retorna o texto concatenado de todos os versículos ou null se não encontrar
  static Future<String?> buscarTextoLeitura(String referencia) async {
    try {
      final versiculos = await BibliaService.buscarVersiculosPorReferencia(
        referencia,
      );
      if (versiculos == null || versiculos.isEmpty) return null;

      // Concatena todos os versículos
      return versiculos.map((v) => v.texto).join(' ');
    } catch (e) {
      return null;
    }
  }

  /// Preenche os textos de todas as leituras de uma liturgia
  /// Retorna uma nova instância de LiturgiaDiaria com os textos preenchidos
  static Future<LiturgiaDiaria> preencherTextosLeituras(
    LiturgiaDiaria liturgia,
  ) async {
    final leiturasComTexto = <LeituraLiturgica>[];

    for (final leitura in liturgia.leituras) {
      // Se já tem texto, mantém
      if (leitura.texto != null && leitura.texto!.isNotEmpty) {
        leiturasComTexto.add(leitura);
        continue;
      }

      // Busca o texto pela referência
      final texto = await buscarTextoLeitura(leitura.referencia);
      leiturasComTexto.add(
        LeituraLiturgica(
          referencia: leitura.referencia,
          titulo: leitura.titulo,
          texto: texto,
        ),
      );
    }

    return LiturgiaDiaria(
      data: liturgia.data,
      corLiturgica: liturgia.corLiturgica,
      tempoLiturgico: liturgia.tempoLiturgico,
      solenidade: liturgia.solenidade,
      festa: liturgia.festa,
      memoria: liturgia.memoria,
      leituras: leiturasComTexto,
      salmo: liturgia.salmo,
      salmoTexto: liturgia.salmoTexto,
      aclamacao: liturgia.aclamacao,
      oracao: liturgia.oracao,
      santoDoDia: liturgia.santoDoDia,
    );
  }
}
