import '../../models/biblia_models.dart';

/// Resultado do parsing de uma referência bíblica
class ReferenciaBiblica {
  final String abreviacao;
  final int capitulo;
  final int? versiculoInicio;
  final int? versiculoFim;
  final int? capituloFim; // Para casos como "Jo 2,29-3,6"

  ReferenciaBiblica({
    required this.abreviacao,
    required this.capitulo,
    this.versiculoInicio,
    this.versiculoFim,
    this.capituloFim,
  });

  /// Retorna true se a referência é apenas um capítulo (sem versículos)
  bool get isApenasCapitulo => versiculoInicio == null && versiculoFim == null;

  /// Retorna true se a referência é um range de versículos
  bool get isRangeVersiculos => versiculoInicio != null && versiculoFim != null;

  /// Retorna true se a referência é um único versículo
  bool get isVersiculoUnico => versiculoInicio != null && versiculoFim == null;
}

/// Parser para referências bíblicas no formato usado nas liturgias
/// Exemplos:
/// - "Is 40,1-11" -> Isaías 40:1-11
/// - "Sl 66" -> Salmos 66 (capítulo inteiro)
/// - "Mt 18,12-14" -> Mateus 18:12-14
/// - "Jo 2,29-3,6" -> João 2:29 até 3:6
class ReferenciaBiblicaParser {
  /// Parseia uma referência bíblica
  /// Retorna null se não conseguir parsear
  static ReferenciaBiblica? parsear(String referencia) {
    if (referencia.isEmpty) return null;

    // Remove espaços extras
    referencia = referencia.trim();

    // Caso especial: "Jo 2,29-3,6" (dois capítulos)
    // Padrão: abreviação espaço capítulo vírgula versículo hífen capítulo vírgula versículo
    final regexDoisCapitulos = RegExp(
      r'^([A-Za-zÀ-ÿ0-9]+)\s+(\d+),(\d+)-(\d+),(\d+)$',
    );
    final matchDoisCapitulos = regexDoisCapitulos.firstMatch(referencia);
    if (matchDoisCapitulos != null) {
      final abreviacao = matchDoisCapitulos.group(1)?.trim() ?? '';
      final capitulo = int.tryParse(matchDoisCapitulos.group(2) ?? '');
      final versiculoInicio = int.tryParse(matchDoisCapitulos.group(3) ?? '');
      final capituloFim = int.tryParse(matchDoisCapitulos.group(4) ?? '');
      final versiculoFim = int.tryParse(matchDoisCapitulos.group(5) ?? '');

      if (capitulo != null &&
          versiculoInicio != null &&
          capituloFim != null &&
          versiculoFim != null) {
        return ReferenciaBiblica(
          abreviacao: abreviacao,
          capitulo: capitulo,
          versiculoInicio: versiculoInicio,
          versiculoFim: versiculoFim,
          capituloFim: capituloFim,
        );
      }
    }

    // Caso normal: "Is 40,1-11" ou "Is 40,1" ou "Sl 66"
    // Padrão: abreviação espaço capítulo [vírgula versículo [hífen versículo]]
    final regex = RegExp(r'^([A-Za-zÀ-ÿ0-9]+)\s+(\d+)(?:,(\d+)(?:-(\d+))?)?$');

    final match = regex.firstMatch(referencia);
    if (match == null) return null;

    final abreviacao = match.group(1)?.trim() ?? '';
    final capituloStr = match.group(2) ?? '';
    final versiculoInicioStr = match.group(3);
    final versiculoFimStr = match.group(4);

    final capitulo = int.tryParse(capituloStr);
    if (capitulo == null) return null;

    // Caso normal: "Is 40,1-11" ou "Is 40,1" ou "Sl 66"
    final versiculoInicio = versiculoInicioStr != null
        ? int.tryParse(versiculoInicioStr)
        : null;
    final versiculoFim = versiculoFimStr != null
        ? int.tryParse(versiculoFimStr)
        : null;

    return ReferenciaBiblica(
      abreviacao: abreviacao,
      capitulo: capitulo,
      versiculoInicio: versiculoInicio,
      versiculoFim: versiculoFim,
    );
  }

  /// Busca um livro na Bíblia pela abreviação
  static Livro? buscarLivroPorAbreviacao(Biblia biblia, String abreviacao) {
    // Normaliza a abreviação (remove espaços, converte para maiúscula)
    final abreviacaoNormalizada = abreviacao.trim();

    // Busca em todos os livros
    for (final livro in biblia.todosLivros) {
      if (livro.abreviacao.toLowerCase() ==
          abreviacaoNormalizada.toLowerCase()) {
        return livro;
      }
    }

    return null;
  }

  /// Busca versículos por referência bíblica
  /// Retorna uma lista de versículos ou null se não encontrar
  static List<Versiculo>? buscarVersiculos(
    Biblia biblia,
    ReferenciaBiblica referencia,
  ) {
    final livro = buscarLivroPorAbreviacao(biblia, referencia.abreviacao);
    if (livro == null) return null;

    // Busca o capítulo
    final capitulo = livro.capitulos.firstWhere(
      (c) => c.numero == referencia.capitulo,
      orElse: () => Capitulo(numero: 0, versiculos: []),
    );

    if (capitulo.numero == 0) return null;

    // Se não tem versículos especificados, retorna todos do capítulo
    if (referencia.isApenasCapitulo) {
      return capitulo.versiculos;
    }

    // Se tem range de versículos
    if (referencia.isRangeVersiculos) {
      final inicio = referencia.versiculoInicio!;
      final fim = referencia.versiculoFim!;

      // Se tem capítulo final (ex: "Jo 2,29-3,6")
      if (referencia.capituloFim != null) {
        final versiculos = <Versiculo>[];

        // Versículos do capítulo inicial
        versiculos.addAll(capitulo.versiculos.where((v) => v.numero >= inicio));

        // Versículos do capítulo final
        final capituloFim = livro.capitulos.firstWhere(
          (c) => c.numero == referencia.capituloFim,
          orElse: () => Capitulo(numero: 0, versiculos: []),
        );

        if (capituloFim.numero != 0) {
          versiculos.addAll(
            capituloFim.versiculos.where(
              (v) => v.numero <= referencia.versiculoFim!,
            ),
          );
        }

        return versiculos;
      }

      // Range normal no mesmo capítulo
      return capitulo.versiculos
          .where((v) => v.numero >= inicio && v.numero <= fim)
          .toList();
    }

    // Versículo único
    if (referencia.isVersiculoUnico) {
      return capitulo.versiculos
          .where((v) => v.numero == referencia.versiculoInicio)
          .toList();
    }

    return null;
  }

  /// Busca versículos por string de referência (método conveniente)
  static List<Versiculo>? buscarVersiculosPorString(
    Biblia biblia,
    String referencia,
  ) {
    final ref = parsear(referencia);
    if (ref == null) return null;
    return buscarVersiculos(biblia, ref);
  }
}
